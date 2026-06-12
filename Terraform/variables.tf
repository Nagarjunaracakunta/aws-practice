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

