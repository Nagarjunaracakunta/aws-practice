variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow bucket to be destroyed even if it contains objects"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "KMS key ARN for server-side encryption. Defaults to AES256 if empty"
  type        = string
  default     = ""
}

variable "bucket_policy_json" {
  description = "JSON bucket policy to attach. Leave empty to skip"
  type        = string
  default     = ""
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id                                  = string
    enabled                             = bool
    prefix                              = string
    expiration_days                     = optional(number)
    noncurrent_version_expiration_days  = optional(number)
  }))
  default = []
}

variable "cors_rules" {
  description = "List of CORS rules for the bucket"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = []
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
