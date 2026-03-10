variable "name" {
  description = "Name for the ASG and launch template"
  type        = string
  nullable    = false
}

variable "ami_id" {
  description = "AMI ID for the launch template"
  type        = string

  validation {
    condition     = startswith(var.ami_id, "ami-")
    error_message = "The ami_id must start with 'ami-'."
  }

  nullable = false
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ASG"
  type        = list(string)
  nullable    = false
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  nullable    = false
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  nullable    = false
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
  default     = null
}

variable "target_group_arns" {
  description = "List of target group ARNs to attach"
  type        = list(string)
  default     = []
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
