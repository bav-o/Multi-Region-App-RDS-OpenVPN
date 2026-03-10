output "public_zone_id" {
  description = "The ID of the public Route 53 zone"
  value       = module.public_dns.zone_id
}

output "public_zone_name_servers" {
  description = "The name servers for the public Route 53 zone"
  value       = module.public_dns.zone_name_servers
}

output "private_zone_id" {
  description = "The ID of the private Route 53 zone"
  value       = module.private_dns.zone_id
}
