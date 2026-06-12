variable "user_pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
}

variable "username_attributes" {
  description = "Attributes used as username: email, phone_number"
  type        = list(string)
  default     = ["email"]
}

variable "auto_verified_attributes" {
  description = "Attributes to auto-verify"
  type        = list(string)
  default     = ["email"]
}

variable "password_minimum_length" {
  description = "Minimum password length"
  type        = number
  default     = 12
}

variable "password_require_lowercase" {
  description = "Require lowercase letters in passwords"
  type        = bool
  default     = true
}

variable "password_require_numbers" {
  description = "Require numbers in passwords"
  type        = bool
  default     = true
}

variable "password_require_symbols" {
  description = "Require symbols in passwords"
  type        = bool
  default     = true
}

variable "password_require_uppercase" {
  description = "Require uppercase letters in passwords"
  type        = bool
  default     = true
}

variable "temporary_password_validity_days" {
  description = "Days that a temporary password is valid"
  type        = number
  default     = 7
}

variable "mfa_configuration" {
  description = "MFA configuration: OFF, ON, or OPTIONAL"
  type        = string
  default     = "OPTIONAL"
}

variable "ses_email_arn" {
  description = "SES verified email ARN for sending emails. Leave empty to use Cognito default"
  type        = string
  default     = ""
}

variable "ses_from_email" {
  description = "From email address when using SES"
  type        = string
  default     = ""
}

variable "schema_attributes" {
  description = "List of custom schema attributes for the user pool"
  type        = list(any)
  default     = []
}

variable "allow_admin_create_user_only" {
  description = "Only allow admins to create users (disables self-registration)"
  type        = bool
  default     = false
}

variable "verification_email_subject" {
  description = "Subject of verification emails"
  type        = string
  default     = "Your verification code"
}

variable "verification_email_message" {
  description = "Body of verification emails. Must contain {####}"
  type        = string
  default     = "Your verification code is {####}"
}

variable "app_clients" {
  description = "List of app client configurations"
  type        = list(any)
  default = [{
    name = "web-client"
  }]
}

variable "domain" {
  description = "Cognito hosted UI domain prefix. Leave empty to skip"
  type        = string
  default     = ""
}

variable "create_identity_pool" {
  description = "Whether to create a Cognito Identity Pool"
  type        = bool
  default     = false
}

variable "allow_unauthenticated_identities" {
  description = "Allow unauthenticated identities in the identity pool"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
