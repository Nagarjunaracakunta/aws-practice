variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "billing_mode" {
  description = "DynamoDB billing mode: PAY_PER_REQUEST or PROVISIONED"
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode must be PAY_PER_REQUEST or PROVISIONED."
  }
}

variable "read_capacity" {
  description = "Read capacity units (required when billing_mode is PROVISIONED)"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity units (required when billing_mode is PROVISIONED)"
  type        = number
  default     = 5
}

variable "hash_key" {
  description = "Name of the hash (partition) key attribute"
  type        = string
}

variable "hash_key_type" {
  description = "Type of the hash key attribute: S (string), N (number), or B (binary)"
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "Name of the range (sort) key attribute. Leave empty if not needed"
  type        = string
  default     = ""
}

variable "range_key_type" {
  description = "Type of the range key attribute"
  type        = string
  default     = "S"
}

variable "additional_attributes" {
  description = "Additional attributes needed for GSIs or LSIs"
  type = list(object({
    name = string
    type = string
  }))
  default = []
}

variable "global_secondary_indexes" {
  description = "List of Global Secondary Index definitions"
  type        = list(any)
  default     = []
}

variable "local_secondary_indexes" {
  description = "List of Local Secondary Index definitions"
  type        = list(any)
  default     = []
}

variable "stream_enabled" {
  description = "Enable DynamoDB streams"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Stream view type: KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}

variable "point_in_time_recovery" {
  description = "Enable Point-in-Time Recovery"
  type        = bool
  default     = true
}

variable "ttl_attribute" {
  description = "Name of the TTL attribute. Leave empty to disable TTL"
  type        = string
  default     = ""
}

variable "enable_autoscaling" {
  description = "Enable auto scaling for provisioned capacity"
  type        = bool
  default     = false
}

variable "autoscaling_read_max" {
  description = "Maximum read capacity for autoscaling"
  type        = number
  default     = 100
}

variable "autoscaling_write_max" {
  description = "Maximum write capacity for autoscaling"
  type        = number
  default     = 100
}

variable "autoscaling_target_utilization" {
  description = "Target utilization percentage for autoscaling"
  type        = number
  default     = 70
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
