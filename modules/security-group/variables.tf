variable "name" {
  description = "Name of the security group"
  type        = string
  nullable    = false
}

variable "description" {
  description = "Description of the security group"
  type        = string
  nullable    = false
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
  nullable    = false
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string), [])
    source_security_group_id = optional(string, null)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    description                   = string
    from_port                     = number
    to_port                       = number
    protocol                      = string
    cidr_blocks                   = optional(list(string), [])
    destination_security_group_id = optional(string, null)
  }))
  default = [
    {
      description = "All outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
}
