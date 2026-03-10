# DR-ready database layer for eu-central-1.
# This layer provisions the DB subnet group and security group only.
# To restore from backup:
#   1. Use the RDS console or CLI to restore a snapshot from the cross-region backup
#   2. Specify the DB subnet group and security group created by this layer
#   3. Update the DNS records in the dns/ layer to point to the new endpoint

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "prod/eu-central-1/networking/terraform.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-${var.environment}-dr"
  subnet_ids = data.terraform_remote_state.networking.outputs.data_subnet_ids

  tags = local.common_tags
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Region      = var.region
    ManagedBy   = "terraform"
  }
}
