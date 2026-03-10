variable "name" {
  description = "Name for the VPC peering connection"
  type        = string
  nullable    = false
}

variable "requester_vpc_id" {
  description = "ID of the requester VPC"
  type        = string
  nullable    = false
}

variable "accepter_vpc_id" {
  description = "ID of the accepter VPC"
  type        = string
  nullable    = false
}

variable "requester_vpc_cidr" {
  description = "CIDR block of the requester VPC"
  type        = string
  nullable    = false
}

variable "accepter_vpc_cidr" {
  description = "CIDR block of the accepter VPC"
  type        = string
  nullable    = false
}

variable "requester_route_table_ids" {
  description = "List of route table IDs in the requester VPC to add peer routes"
  type        = list(string)
  nullable    = false
}

variable "accepter_route_table_ids" {
  description = "List of route table IDs in the accepter VPC to add peer routes"
  type        = list(string)
  nullable    = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
