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

# ─── DynamoDB ──────────────────────────────────────────────────────────────────

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.dynamodb.table_arn
}

# ─── Cognito ───────────────────────────────────────────────────────────────────

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_arn" {
  description = "Cognito User Pool ARN"
  value       = module.cognito.user_pool_arn
}

output "cognito_web_client_id" {
  description = "Cognito web app client ID"
  value       = module.cognito.client_ids["web-client"]
}

output "cognito_hosted_ui_url" {
  description = "Cognito Hosted UI base URL (if domain configured)"
  value       = module.cognito.hosted_ui_url
}

# ─── Lambda ────────────────────────────────────────────────────────────────────

output "lambda_function_name" {
  description = "Name of the API Lambda function"
  value       = module.lambda_api.function_name
}

output "lambda_function_arn" {
  description = "ARN of the API Lambda function"
  value       = module.lambda_api.function_arn
}

output "lambda_log_group" {
  description = "CloudWatch log group for the Lambda function"
  value       = module.lambda_api.log_group_name
}

# ─── API Gateway ───────────────────────────────────────────────────────────────

output "api_invoke_url" {
  description = "Base invoke URL for the API Gateway stage"
  value       = module.api_gateway.stage_invoke_url
}

output "api_id" {
  description = "REST API ID"
  value       = module.api_gateway.api_id
}

# ─── EC2 ───────────────────────────────────────────────────────────────────────

output "ec2_instance_ids" {
  description = "IDs of the EC2 instances"
  value       = module.ec2.instance_ids
}

output "ec2_private_ips" {
  description = "Private IPs of the EC2 instances"
  value       = module.ec2.private_ips
}
