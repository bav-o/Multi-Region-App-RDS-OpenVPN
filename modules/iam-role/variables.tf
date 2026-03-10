variable "name" {
  description = "Name for the IAM role and instance profile"
  type        = string
  nullable    = false
}

variable "additional_policy_arns" {
  description = "List of additional IAM policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
