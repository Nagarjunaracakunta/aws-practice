variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Function entrypoint in your code (e.g. index.handler)"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda runtime identifier"
  type        = string
  default     = "nodejs20.x"
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Amount of memory in MB for the Lambda function"
  type        = number
  default     = 128
}

variable "filename" {
  description = "Path to the function's deployment package zip file. Use when deploying from local file"
  type        = string
  default     = ""
}

variable "s3_bucket" {
  description = "S3 bucket containing the deployment package"
  type        = string
  default     = ""
}

variable "s3_key" {
  description = "S3 key of the deployment package"
  type        = string
  default     = ""
}

variable "source_code_hash" {
  description = "Base64-encoded SHA256 hash of the package file"
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = "Map of environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "vpc_config" {
  description = "VPC configuration for the Lambda function. Set to null for no VPC"
  type = object({
    vpc_id                       = string
    subnet_ids                   = list(string)
    additional_security_group_ids = optional(list(string), [])
  })
  default = null
}

variable "iam_policy_arns" {
  description = "List of IAM policy ARNs to attach to the Lambda role"
  type        = list(string)
  default     = []
}

variable "inline_policy_json" {
  description = "Inline IAM policy JSON to attach to the Lambda role"
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}

variable "enable_xray" {
  description = "Enable AWS X-Ray tracing"
  type        = bool
  default     = false
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrent executions (-1 for unreserved)"
  type        = number
  default     = -1
}

variable "create_alias" {
  description = "Whether to create a 'live' alias for the function"
  type        = bool
  default     = false
}

variable "api_gateway_source_arn" {
  description = "Source ARN for API Gateway invocation permission. Leave empty if not invoked by API Gateway"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
