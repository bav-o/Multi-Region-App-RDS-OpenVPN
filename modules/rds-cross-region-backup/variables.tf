variable "name" {
  description = "Identifier for the backup replication"
  type        = string
  nullable    = false
}

variable "source_db_instance_arn" {
  description = "ARN of the source RDS instance to replicate backups from"
  type        = string
  nullable    = false
}

variable "kms_key_arn" {
  description = "KMS key ARN in the destination region for encrypting replicated backups"
  type        = string
  nullable    = false
}

variable "retention_period" {
  description = "Number of days to retain replicated backups"
  type        = number
  default     = 14

  validation {
    condition     = var.retention_period >= 1 && var.retention_period <= 35
    error_message = "The retention_period must be between 1 and 35 days."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
