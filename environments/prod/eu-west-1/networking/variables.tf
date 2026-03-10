variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "project" {
  description = "Project name"
  type        = string
  nullable    = false
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment must be one of: dev, staging, prod."
  }
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "data_subnets" {
  description = "Data subnet CIDRs for RDS"
  type        = list(string)
}

variable "admin_cidr_blocks" {
  description = "CIDR blocks allowed SSH access to OpenVPN"
  type        = list(string)

  validation {
    condition     = alltrue([for cidr in var.admin_cidr_blocks : tonumber(split("/", cidr)[1]) > 8])
    error_message = "Admin CIDR blocks must be more specific than /8. Use narrow ranges for admin access."
  }
}

variable "peer_app_subnet_cidrs" {
  description = "CIDR blocks of eu-central-1 app subnets (for cross-region RDS access)"
  type        = list(string)
}
