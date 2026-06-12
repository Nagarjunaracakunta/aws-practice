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

# ─── EC2 ───────────────────────────────────────────────────────────────────────

module "ec2" {
  source = "./modules/ec2"

  name           = "${local.name}-app"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.public_subnet_ids
  instance_type  = var.ec2_instance_type
  instance_count = var.ec2_instance_count
  public_key     = var.ec2_public_key

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    }
  ]

  iam_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  ]

  tags = local.tags
}
