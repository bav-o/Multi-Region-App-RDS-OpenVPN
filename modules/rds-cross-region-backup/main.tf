################################################################################
# Cross-Region Automated Backup Replication
################################################################################

resource "aws_db_instance_automated_backups_replication" "this" {
  source_db_instance_arn = var.source_db_instance_arn
  kms_key_id             = var.kms_key_arn
  retention_period       = var.retention_period
}
