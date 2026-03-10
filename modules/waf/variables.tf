variable "name" {
  description = "Name for the WAF web ACL"
  type        = string
  nullable    = false
}

variable "alb_arns" {
  description = "List of ALB ARNs to associate with the WAF"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
