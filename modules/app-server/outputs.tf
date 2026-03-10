output "instance_id" {
  description = "ID of the app server EC2 instance"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP address of the app server instance"
  value       = aws_instance.this.private_ip
}
