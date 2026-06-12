# ─── Global ────────────────────────────────────────────────────────────────────

variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for naming and tagging resources"
  type        = string
  default     = "aws-practice"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# ─── VPC ───────────────────────────────────────────────────────────────────────

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "enable_nat_gateway" {
  description = "Create a NAT Gateway for private subnets"
  type        = bool
  default     = true
}

# ─── EC2 ───────────────────────────────────────────────────────────────────────

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
  default     = 1
}

variable "ec2_public_key" {
  description = "SSH public key for EC2 key pair. Leave empty to skip"
  type        = string
  default     = ""
  sensitive   = true
}

# ─── S3 ────────────────────────────────────────────────────────────────────────

variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name for application assets"
  type        = string
}

variable "s3_enable_versioning" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

# ─── DynamoDB ──────────────────────────────────────────────────────────────────

variable "dynamodb_table_name" {
  description = "Name of the primary DynamoDB table"
  type        = string
  default     = "app-table"
}

variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode: PAY_PER_REQUEST or PROVISIONED"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_hash_key" {
  description = "Hash (partition) key attribute name"
  type        = string
  default     = "PK"
}

variable "dynamodb_range_key" {
  description = "Range (sort) key attribute name. Leave empty if not needed"
  type        = string
  default     = "SK"
}

# ─── Lambda ────────────────────────────────────────────────────────────────────

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "nodejs20.x"
}

variable "lambda_memory_size" {
  description = "Lambda function memory in MB"
  type        = number
  default     = 256
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

# ─── API Gateway ───────────────────────────────────────────────────────────────

variable "api_stage_name" {
  description = "API Gateway stage name"
  type        = string
  default     = "v1"
}

variable "api_throttling_rate_limit" {
  description = "API Gateway rate limit (requests/sec)"
  type        = number
  default     = 10000
}

variable "api_throttling_burst_limit" {
  description = "API Gateway burst limit"
  type        = number
  default     = 5000
}

# ─── Cognito ───────────────────────────────────────────────────────────────────

variable "cognito_domain_prefix" {
  description = "Cognito hosted UI domain prefix (must be globally unique). Leave empty to skip"
  type        = string
  default     = ""
}

variable "cognito_mfa" {
  description = "MFA configuration for Cognito: OFF, OPTIONAL, or ON"
  type        = string
  default     = "OPTIONAL"
}
