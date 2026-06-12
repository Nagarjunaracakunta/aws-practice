output "user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.this.arn
}

output "user_pool_endpoint" {
  description = "Endpoint of the Cognito User Pool"
  value       = aws_cognito_user_pool.this.endpoint
}

output "client_ids" {
  description = "Map of app client name to client ID"
  value       = { for k, v in aws_cognito_user_pool_client.this : k => v.id }
}

output "client_secrets" {
  description = "Map of app client name to client secret (sensitive)"
  value       = { for k, v in aws_cognito_user_pool_client.this : k => v.client_secret }
  sensitive   = true
}

output "domain" {
  description = "Cognito hosted UI domain (if created)"
  value       = var.domain != "" ? aws_cognito_user_pool_domain.this[0].domain : null
}

output "hosted_ui_url" {
  description = "Hosted UI base URL (if domain created)"
  value       = var.domain != "" ? "https://${var.domain}.auth.${data.aws_region.current.name}.amazoncognito.com" : null
}

output "identity_pool_id" {
  description = "ID of the Cognito Identity Pool (if created)"
  value       = var.create_identity_pool ? aws_cognito_identity_pool.this[0].id : null
}

data "aws_region" "current" {}
