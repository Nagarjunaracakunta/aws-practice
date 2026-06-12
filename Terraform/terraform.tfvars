aws_region   = "us-east-1"
project_name = "aws-practice"
environment  = "dev"

# VPC
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
enable_nat_gateway   = false

# EC2
ec2_instance_type  = "t3.micro"
ec2_instance_count = 1
# ec2_public_key = "ssh-rsa AAAA..."   # paste your public key to enable SSH key auth

# S3 — must be globally unique across all AWS accounts
s3_bucket_name       = "aws-practice-dev-assets-CHANGEME"
s3_enable_versioning = true
