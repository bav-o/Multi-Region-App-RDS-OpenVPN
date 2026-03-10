variable "org_name" {
  description = "Organisation name prefix for resource naming"
  type        = string
  nullable    = false
}

variable "environment" {
  description = "Environment name (e.g. prod)"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment must be one of: dev, staging, prod."
  }
}

variable "region" {
  description = "AWS region for the state resources"
  type        = string
  default     = "eu-west-1"
}
