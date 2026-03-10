variable "name" {
  description = "Name prefix for monitoring resources"
  type        = string
  nullable    = false
}

variable "alb_arn_suffix" {
  description = "ARN suffix of the ALB for CloudWatch metrics"
  type        = string
  default     = null
}

variable "alb_target_group_arn_suffix" {
  description = "ARN suffix of the ALB target group"
  type        = string
  default     = null
}

variable "rds_instance_id" {
  description = "RDS instance identifier for CloudWatch metrics"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
