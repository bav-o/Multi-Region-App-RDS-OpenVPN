output "replication_id" {
  description = "The ID of the automated backups replication"
  value       = aws_db_instance_automated_backups_replication.this.id
}
