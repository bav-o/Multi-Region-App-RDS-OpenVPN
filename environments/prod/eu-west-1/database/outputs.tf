output "db_instance_id" {
  description = "RDS instance ID"
  value       = module.rds.db_instance_id
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = module.rds.db_instance_arn
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.db_endpoint
}

output "db_address" {
  description = "RDS address (hostname only)"
  value       = module.rds.db_address
}

output "db_port" {
  description = "RDS port"
  value       = module.rds.db_port
}

output "kms_key_arn" {
  description = "KMS key ARN used for RDS encryption"
  value       = module.rds.kms_key_arn
}

output "master_user_secret_arn" {
  description = "Secrets Manager secret ARN for master user"
  value       = module.rds.master_user_secret_arn
}
