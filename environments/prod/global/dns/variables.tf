variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "state_bucket" {
  description = "S3 bucket for Terraform remote state"
  type        = string
}

variable "public_domain" {
  description = "Public DNS domain name"
  type        = string
}

variable "private_domain" {
  description = "Private DNS domain name"
  type        = string
}
