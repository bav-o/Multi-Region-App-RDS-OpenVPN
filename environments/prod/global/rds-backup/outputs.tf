output "replication_id" {
  description = "The ID of the RDS cross-region backup replication"
  value       = module.rds_backup.replication_id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for RDS backup encryption"
  value       = aws_kms_key.rds_backup.arn
}
