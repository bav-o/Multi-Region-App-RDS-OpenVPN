variable "domain_name" {
  description = "The domain name for the Route 53 hosted zone"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]+\\.[a-z]{2,}$", var.domain_name))
    error_message = "The domain_name must be a valid domain (e.g. 'example.com')."
  }

  nullable = false
}

variable "is_private" {
  description = "Whether the hosted zone is private"
  type        = bool
  default     = false
}

variable "vpc_associations" {
  description = "List of VPC associations for private hosted zones"
  type = list(object({
    vpc_id     = string
    vpc_region = string
  }))
  default = []
}

variable "records" {
  description = "List of DNS records to create"
  type = list(object({
    name                    = string
    type                    = string
    ttl                     = optional(number, 300)
    values                  = optional(list(string), [])
    set_identifier          = optional(string, null)
    health_check_id         = optional(string, null)
    failover_routing_policy = optional(string, null)
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool, true)
    }), null)
  }))
  nullable = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "health_checks" {
  description = "List of Route 53 health checks to create"
  type = list(object({
    name              = string
    ip_address        = string
    port              = optional(number, 443)
    type              = optional(string, "HTTPS")
    resource_path     = optional(string, "/")
    failure_threshold = optional(number, 3)
    request_interval  = optional(number, 30)
  }))
  default = []
}
