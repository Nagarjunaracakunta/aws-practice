locals {
  name = "${var.project_name}-${var.environment}"
  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# ─── VPC ───────────────────────────────────────────────────────────────────────

module "vpc" {
  source = "./modules/vpc"

  name                 = local.name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, length(var.public_subnet_cidrs))
  enable_nat_gateway   = var.enable_nat_gateway
  tags                 = local.tags
}

# ─── S3 ────────────────────────────────────────────────────────────────────────

module "s3_app" {
  source = "./modules/s3"

  bucket_name       = var.s3_bucket_name
  enable_versioning = var.s3_enable_versioning
  tags              = local.tags

  lifecycle_rules = [
    {
      id                                 = "expire-old-versions"
      enabled                            = true
      prefix                             = ""
      noncurrent_version_expiration_days = 90
      expiration_days                    = null
    }
  ]
}

# ─── DynamoDB ──────────────────────────────────────────────────────────────────

module "dynamodb" {
  source = "./modules/dynamodb"

  table_name             = "${local.name}-${var.dynamodb_table_name}"
  billing_mode           = var.dynamodb_billing_mode
  hash_key               = var.dynamodb_hash_key
  range_key              = var.dynamodb_range_key
  point_in_time_recovery = true
  tags                   = local.tags
}

# ─── Cognito ───────────────────────────────────────────────────────────────────

module "cognito" {
  source = "./modules/cognito"

  user_pool_name     = "${local.name}-user-pool"
  mfa_configuration  = var.cognito_mfa
  domain             = var.cognito_domain_prefix
  tags               = local.tags

  app_clients = [
    {
      name                  = "web-client"
      generate_secret       = false
      explicit_auth_flows   = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH"]
      access_token_validity = 1
      id_token_validity     = 1
      refresh_token_validity = 30
    }
  ]
}

# ─── Lambda ────────────────────────────────────────────────────────────────────

module "lambda_api" {
  source = "./modules/lambda"

  function_name = "${local.name}-api-handler"
  description   = "Main API handler Lambda for ${local.name}"
  handler       = "index.handler"
  runtime       = var.lambda_runtime
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout

  # Provide a placeholder zip or point to your build artifact
  filename         = "${path.module}/lambda/placeholder.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/placeholder.zip")

  vpc_config = {
    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnet_ids
  }

  environment_variables = {
    ENVIRONMENT        = var.environment
    DYNAMODB_TABLE     = module.dynamodb.table_name
    S3_BUCKET          = module.s3_app.bucket_id
    COGNITO_USER_POOL  = module.cognito.user_pool_id
  }

  iam_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  ]

  api_gateway_source_arn = module.api_gateway.execution_arn
  log_retention_days     = 14
  tags                   = local.tags
}

# ─── API Gateway ───────────────────────────────────────────────────────────────

module "api_gateway" {
  source = "./modules/api_gateway"

  api_name   = "${local.name}-api"
  stage_name = var.api_stage_name
  enable_cors = true

  resources = [
    { path_part = "users" },
    { path_part = "items" },
    { path_part = "health" },
  ]

  methods = [
    {
      resource_path     = "health"
      http_method       = "GET"
      authorization     = "NONE"
      lambda_invoke_arn = module.lambda_api.invoke_arn
    },
    {
      resource_path     = "users"
      http_method       = "GET"
      authorization     = "COGNITO_USER_POOLS"
      lambda_invoke_arn = module.lambda_api.invoke_arn
    },
    {
      resource_path     = "users"
      http_method       = "POST"
      authorization     = "COGNITO_USER_POOLS"
      lambda_invoke_arn = module.lambda_api.invoke_arn
    },
    {
      resource_path     = "items"
      http_method       = "GET"
      authorization     = "COGNITO_USER_POOLS"
      lambda_invoke_arn = module.lambda_api.invoke_arn
    },
    {
      resource_path     = "items"
      http_method       = "POST"
      authorization     = "COGNITO_USER_POOLS"
      lambda_invoke_arn = module.lambda_api.invoke_arn
    },
  ]

  cognito_user_pool_arns     = [module.cognito.user_pool_arn]
  throttling_rate_limit      = var.api_throttling_rate_limit
  throttling_burst_limit     = var.api_throttling_burst_limit
  tags                       = local.tags
}

# ─── EC2 ───────────────────────────────────────────────────────────────────────

module "ec2" {
  source = "./modules/ec2"

  name           = "${local.name}-app"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids
  instance_type  = var.ec2_instance_type
  instance_count = var.ec2_instance_count
  public_key     = var.ec2_public_key

  ingress_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
      description = "App port from VPC"
    }
  ]

  iam_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  ]

  tags = local.tags
}
