# ─── VPC ───────────────────────────────────────────────────────────────────────

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

# ─── S3 ────────────────────────────────────────────────────────────────────────

output "s3_bucket_name" {
  description = "Name of the application S3 bucket"
  value       = module.s3_app.bucket_id
}

output "s3_bucket_arn" {
  description = "ARN of the application S3 bucket"
  value       = module.s3_app.bucket_arn
}

# ─── EC2 ───────────────────────────────────────────────────────────────────────

output "ec2_instance_ids" {
  description = "IDs of the EC2 instances"
  value       = module.ec2.instance_ids
}

output "ec2_public_ips" {
  description = "Public IPs of the EC2 instances"
  value       = module.ec2.public_ips
}

output "ec2_private_ips" {
  description = "Private IPs of the EC2 instances"
  value       = module.ec2.private_ips
}

output "ec2_security_group_id" {
  description = "Security group ID attached to EC2 instances"
  value       = module.ec2.security_group_id
}
