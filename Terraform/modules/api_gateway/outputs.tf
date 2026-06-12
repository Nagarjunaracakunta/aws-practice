output "api_id" {
  description = "ID of the REST API"
  value       = aws_api_gateway_rest_api.this.id
}

output "api_arn" {
  description = "ARN of the REST API"
  value       = aws_api_gateway_rest_api.this.arn
}

output "root_resource_id" {
  description = "ID of the root resource"
  value       = aws_api_gateway_rest_api.this.root_resource_id
}

output "stage_invoke_url" {
  description = "Invoke URL for the deployed stage"
  value       = aws_api_gateway_stage.this.invoke_url
}

output "stage_arn" {
  description = "ARN of the API Gateway stage"
  value       = aws_api_gateway_stage.this.arn
}

output "execution_arn" {
  description = "Execution ARN for use in Lambda permission source_arn"
  value       = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

output "authorizer_id" {
  description = "ID of the Cognito authorizer (if created)"
  value       = var.cognito_user_pool_arns != null ? aws_api_gateway_authorizer.cognito[0].id : null
}
