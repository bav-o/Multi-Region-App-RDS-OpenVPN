variable "name" {
  description = "Name for the app server instance"
  type        = string
  nullable    = false
}

variable "ami_id" {
  description = "AMI ID for the app server instance"
  type        = string

  validation {
    condition     = startswith(var.ami_id, "ami-")
    error_message = "The ami_id must start with 'ami-'."
  }

  nullable = false
}

variable "instance_type" {
  description = "EC2 instance type. WARNING: Burstable instances (t3, t4g) are not recommended for production workloads due to CPU credit throttling."
  type        = string
  default     = "t3.medium"
}

variable "subnet_id" {
  description = "Private subnet ID to launch the instance in"
  type        = string
  nullable    = false
}

variable "security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
  nullable    = false
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  nullable    = false
}

variable "iam_instance_profile" {
  description = "IAM instance profile name for the EC2 instance"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
