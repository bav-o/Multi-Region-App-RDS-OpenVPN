variable "name" {
  description = "Identifier prefix for all resources"
  type        = string
  nullable    = false
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "16.4"

  validation {
    condition     = can(regex("^\\d+\\.\\d+$", var.engine_version))
    error_message = "The engine_version must be in the format 'MAJOR.MINOR' (e.g. '16.4')."
  }
}

variable "instance_class" {
  description = "RDS instance class. WARNING: Burstable instances (db.t3, db.t4g) are not recommended for production workloads due to CPU credit throttling."
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Initial allocated storage in GB"
  type        = number
  default     = 50
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage in GB for autoscaling"
  type        = number
  default     = 200
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  nullable    = false
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
  nullable    = false
}

variable "security_group_ids" {
  description = "List of security group IDs for the DB instance"
  type        = list(string)
  nullable    = false
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 14
}

variable "kms_key_arn" {
  description = "KMS key ARN for encryption. If null, a new KMS key is created."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
