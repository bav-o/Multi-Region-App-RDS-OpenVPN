variable "name" {
  description = "Name prefix for all resources"
  type        = string
  nullable    = false
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr, 0))
    error_message = "The cidr must be a valid CIDR block (e.g. 10.0.0.0/16)."
  }

  nullable = false
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)

  validation {
    condition     = length(var.azs) > 0
    error_message = "At least one availability zone must be specified."
  }

  nullable = false
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  nullable    = false
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  nullable    = false
}

variable "data_subnets" {
  description = "List of CIDR blocks for data subnets (isolated, no NAT)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs to CloudWatch"
  type        = bool
  default     = true
}

variable "flow_logs_retention_days" {
  description = "Number of days to retain VPC flow logs"
  type        = number
  default     = 30
}
