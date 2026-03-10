variable "region" {
  description = "AWS region"
  type        = string
}

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

variable "ami_id" {
  description = "AMI ID for the instance. If null, latest Amazon Linux 2023 is used."
  type        = string
  default     = null
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener. If null, HTTP only."
  type        = string
  default     = null
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 2
}
