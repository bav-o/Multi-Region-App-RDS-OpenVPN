provider "aws" {
  region = "eu-central-1"
}

data "terraform_remote_state" "database" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "prod/eu-west-1/database/terraform.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_kms_key" "rds_backup" {
  description             = "KMS key for cross-region RDS backup replication"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  tags                    = local.common_tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_alias" "rds_backup" {
  name          = "alias/${var.project}-${var.environment}-rds-backup"
  target_key_id = aws_kms_key.rds_backup.key_id
}

module "rds_backup" {
  source = "../../../../modules/rds-cross-region-backup"

  name                   = "${var.project}-${var.environment}-rds-backup"
  source_db_instance_arn = data.terraform_remote_state.database.outputs.db_instance_arn
  kms_key_arn            = aws_kms_key.rds_backup.arn
  retention_period       = 14
  tags                   = local.common_tags
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
