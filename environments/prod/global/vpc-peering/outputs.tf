output "peering_connection_id" {
  description = "VPC Peering Connection ID"
  value       = module.vpc_peering.peering_connection_id
}

output "peering_connection_status" {
  description = "VPC Peering Connection status"
  value       = module.vpc_peering.peering_connection_status
}
