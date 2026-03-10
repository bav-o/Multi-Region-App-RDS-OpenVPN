provider "aws" {
  region = "eu-central-1"
}

variables {
  name                   = "test-backup"
  source_db_instance_arn = "arn:aws:rds:eu-west-1:123456789012:db:test-db"
  kms_key_arn            = "arn:aws:kms:eu-central-1:123456789012:key/test-key-id"
}

run "creates_replication" {
  command = plan

  assert {
    condition     = aws_db_instance_automated_backups_replication.this.retention_period == 14
    error_message = "Default retention period should be 14 days."
  }
}
