output "db_subnet_group_name" {
  description = "Name of the DB subnet group (DR-ready)"
  value       = aws_db_subnet_group.this.name
}

output "sg_rds_id" {
  description = "RDS security group ID (from networking layer)"
  value       = data.terraform_remote_state.networking.outputs.sg_rds_id
}
