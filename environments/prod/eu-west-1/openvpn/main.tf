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

  name = "${var.project}-${var.environment}-openvpn"
  tags = local.common_tags
}

module "openvpn" {
  source = "../../../../modules/openvpn"

  name          = "${var.project}-${var.environment}-openvpn"
  ami_id        = local.ami_id
  instance_type = "t3.small"
  # NOTE: Deploys to subnet[0] (single-AZ). VPN is a single point of entry by design.
  subnet_id            = data.terraform_remote_state.networking.outputs.public_subnet_ids[0]
  security_group_ids   = [data.terraform_remote_state.networking.outputs.sg_openvpn_id]
  key_name             = var.key_name
  iam_instance_profile = module.iam.instance_profile_name
  tags                 = local.common_tags
}
