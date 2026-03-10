provider "aws" {
  region = "eu-west-1"
}

module "compliance" {
  source = "../../../../modules/compliance"

  name = "${var.project}-${var.environment}"
  tags = local.common_tags
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
