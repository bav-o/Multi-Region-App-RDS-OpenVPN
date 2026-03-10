variable "name" {
  description = "Name prefix for compliance resources"
  type        = string
  nullable    = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
