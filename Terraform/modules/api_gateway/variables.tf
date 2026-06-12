variable "api_name" {
  description = "Name of the API Gateway REST API"
  type        = string
}

variable "description" {
  description = "Description of the API"
  type        = string
  default     = ""
}

variable "endpoint_type" {
  description = "API endpoint type: REGIONAL, EDGE, or PRIVATE"
  type        = string
  default     = "REGIONAL"
}

variable "stage_name" {
  description = "Deployment stage name (e.g. dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "resources" {
  description = "List of API resources (path parts) to create under root"
  type = list(object({
    path_part = string
  }))
  default = []
}

variable "methods" {
  description = "List of API methods to create"
  type = list(object({
    resource_path    = string
    http_method      = string
    authorization    = string
    lambda_invoke_arn = string
  }))
  default = []
}

variable "enable_cors" {
  description = "Enable CORS by adding OPTIONS method to all resources"
  type        = bool
  default     = true
}

variable "cors_allow_origin" {
  description = "Allowed origin for CORS (e.g. * or https://example.com)"
  type        = string
  default     = "*"
}

variable "cognito_user_pool_arns" {
  description = "List of Cognito user pool ARNs for the authorizer. Set to null to skip"
  type        = list(string)
  default     = null
}

variable "enable_xray" {
  description = "Enable AWS X-Ray tracing on the stage"
  type        = bool
  default     = false
}

variable "access_log_destination_arn" {
  description = "ARN of CloudWatch log group or Kinesis stream for access logging"
  type        = string
  default     = ""
}

variable "throttling_burst_limit" {
  description = "API stage throttling burst limit"
  type        = number
  default     = 5000
}

variable "throttling_rate_limit" {
  description = "API stage throttling rate limit (requests per second)"
  type        = number
  default     = 10000
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
