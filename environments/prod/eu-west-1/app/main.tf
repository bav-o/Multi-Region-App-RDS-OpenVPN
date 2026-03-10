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

data "terraform_remote_state" "database" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "prod/eu-west-1/database/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

locals {
  ami_id = coalesce(var.ami_id, data.aws_ami.amazon_linux.id)
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Region      = var.region
    ManagedBy   = "terraform"
  }
}

module "iam" {
  source = "../../../../modules/iam-role"

  name = "${var.project}-${var.environment}-app"
  tags = local.common_tags
}

module "alb" {
  source = "../../../../modules/alb"

  name               = "${var.project}-${var.environment}-app"
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  subnet_ids         = data.terraform_remote_state.networking.outputs.private_subnet_ids
  security_group_ids = [data.terraform_remote_state.networking.outputs.sg_alb_id]
  health_check_path  = "/health"
  certificate_arn    = var.certificate_arn
  tags               = local.common_tags
}

module "asg" {
  source = "../../../../modules/asg"

  name                      = "${var.project}-${var.environment}-app"
  ami_id                    = local.ami_id
  instance_type             = "t3.medium"
  subnet_ids                = data.terraform_remote_state.networking.outputs.private_subnet_ids
  security_group_ids        = [data.terraform_remote_state.networking.outputs.sg_app_id]
  key_name                  = var.key_name
  iam_instance_profile_name = module.iam.instance_profile_name
  target_group_arns         = [module.alb.target_group_arn]
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  tags                      = local.common_tags
}

module "monitoring" {
  source = "../../../../modules/monitoring"

  name                        = "${var.project}-${var.environment}-app"
  alb_arn_suffix              = module.alb.alb_arn
  alb_target_group_arn_suffix = module.alb.target_group_arn
  rds_instance_id             = data.terraform_remote_state.database.outputs.db_instance_id
  tags                        = local.common_tags
}

module "waf" {
  source = "../../../../modules/waf"

  name     = "${var.project}-${var.environment}-app-waf"
  alb_arns = [module.alb.alb_arn]
  tags     = local.common_tags
}
