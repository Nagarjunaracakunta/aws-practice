output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "invoke_arn" {
  description = "Invoke ARN for use with API Gateway"
  value       = aws_lambda_function.this.invoke_arn
}

output "qualified_arn" {
  description = "Qualified ARN of the Lambda function"
  value       = aws_lambda_function.this.qualified_arn
}

output "iam_role_arn" {
  description = "ARN of the Lambda IAM role"
  value       = aws_iam_role.lambda.arn
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.this.name
}

output "security_group_id" {
  description = "ID of the Lambda security group (if VPC-enabled)"
  value       = var.vpc_config != null ? aws_security_group.lambda[0].id : null
}

output "alias_arn" {
  description = "ARN of the live alias (if created)"
  value       = var.create_alias ? aws_lambda_alias.live[0].arn : null
}
