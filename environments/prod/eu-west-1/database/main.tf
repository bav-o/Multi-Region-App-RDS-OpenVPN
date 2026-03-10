provider "aws" {
  region = var.region
}

data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "prod/eu-west-1/networking/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "rds" {
  source = "../../../../modules/rds"

  name                    = "${var.project}-${var.environment}"
  db_name                 = var.db_name
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  multi_az                = true
  subnet_ids              = data.terraform_remote_state.networking.outputs.data_subnet_ids
  security_group_ids      = [data.terraform_remote_state.networking.outputs.sg_rds_id]
  backup_retention_period = 14
  tags                    = local.common_tags
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Region      = var.region
    ManagedBy   = "terraform"
  }
}
