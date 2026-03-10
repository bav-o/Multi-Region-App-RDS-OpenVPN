################################################################################
# KMS Key (created only if kms_key_arn is not provided)
################################################################################

resource "aws_kms_key" "this" {
  count = var.kms_key_arn == null ? 1 : 0

  description             = "KMS key for RDS encryption - ${var.name}"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = merge(var.tags, {
    Name = "${var.name}-rds"
  })
}

resource "aws_kms_alias" "this" {
  count = var.kms_key_arn == null ? 1 : 0

  name          = "alias/${var.name}-rds"
  target_key_id = aws_kms_key.this[0].key_id
}

locals {
  kms_key_arn = var.kms_key_arn != null ? var.kms_key_arn : aws_kms_key.this[0].arn
  pg_family   = "postgres${split(".", var.engine_version)[0]}"
}

################################################################################
# DB Subnet Group
################################################################################

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-rds"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-rds"
  })
}

################################################################################
# DB Parameter Group
################################################################################

resource "aws_db_parameter_group" "this" {
  name   = "${var.name}-${local.pg_family}"
  family = local.pg_family

  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name         = "shared_preload_libraries"
    value        = "pg_stat_statements"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "pg_stat_statements.track"
    value = "all"
  }

  tags = merge(var.tags, {
    Name = "${var.name}-${local.pg_family}"
  })
}

################################################################################
# RDS Instance
################################################################################

resource "aws_db_instance" "this" {
  identifier = var.name

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  manage_master_user_password = true
  username                    = "dbadmin"
  db_name                     = var.db_name

  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids
  parameter_group_name   = aws_db_parameter_group.this.name

  storage_encrypted = true
  kms_key_id        = local.kms_key_arn

  backup_retention_period = var.backup_retention_period

  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.name}-final"
  deletion_protection       = true

  performance_insights_enabled = true

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = merge(var.tags, {
    Name = var.name
  })

  lifecycle {
    prevent_destroy = true
  }
}
