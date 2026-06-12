aws_region   = "us-east-1"
project_name = "myapp"
environment  = "dev"

# VPC
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
enable_nat_gateway   = true

# EC2
ec2_instance_type  = "t3.micro"
ec2_instance_count = 1
# ec2_public_key = "ssh-rsa AAAA..."

# S3 — must be globally unique
s3_bucket_name       = "myapp-dev-assets-<account-id>"
s3_enable_versioning = true

# DynamoDB
dynamodb_table_name  = "app-table"
dynamodb_billing_mode = "PAY_PER_REQUEST"
dynamodb_hash_key    = "PK"
dynamodb_range_key   = "SK"

# Lambda
lambda_runtime     = "nodejs20.x"
lambda_memory_size = 256
lambda_timeout     = 30

# API Gateway
api_stage_name             = "v1"
api_throttling_rate_limit  = 10000
api_throttling_burst_limit = 5000

# Cognito
cognito_mfa           = "OPTIONAL"
# cognito_domain_prefix = "myapp-dev"   # must be globally unique
