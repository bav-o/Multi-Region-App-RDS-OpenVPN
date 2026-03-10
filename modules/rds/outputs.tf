output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.this.arn
}

output "db_endpoint" {
  description = "The connection endpoint (host:port)"
  value       = aws_db_instance.this.endpoint
}

output "db_address" {
  description = "The hostname of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "The database port"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "The name of the initial database"
  value       = aws_db_instance.this.db_name
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for encryption"
  value       = local.kms_key_arn
}

output "master_user_secret_arn" {
  description = "The ARN of the Secrets Manager secret for the master user password"
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}
