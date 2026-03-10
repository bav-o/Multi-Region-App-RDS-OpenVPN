output "instance_id" {
  description = "ID of the OpenVPN EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Elastic IP address of the OpenVPN instance"
  value       = aws_eip.this.public_ip
}

output "eip_id" {
  description = "Allocation ID of the Elastic IP"
  value       = aws_eip.this.id
}
