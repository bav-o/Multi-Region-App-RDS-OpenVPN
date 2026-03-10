output "instance_id" {
  description = "OpenVPN instance ID"
  value       = module.openvpn.instance_id
}

output "public_ip" {
  description = "OpenVPN instance public IP"
  value       = module.openvpn.public_ip
}
