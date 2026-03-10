variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
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
  description = "S3 bucket name for Terraform remote state"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "16.4"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Initial allocated storage in GB"
  type        = number
  default     = 50
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage in GB for autoscaling"
  type        = number
  default     = 200
}
