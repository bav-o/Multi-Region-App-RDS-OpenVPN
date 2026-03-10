variable "name" {
  description = "Name for the ALB and target group"
  type        = string
  nullable    = false
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  nullable    = false
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
  nullable    = false
}

variable "security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
  nullable    = false
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
  default     = "/health"
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener. If null, HTTP listener forwards directly."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
