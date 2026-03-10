provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "eu_central_1"
  region = "eu-central-1"
}

data "terraform_remote_state" "networking_west" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "prod/eu-west-1/networking/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "networking_central" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "prod/eu-central-1/networking/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "vpc_peering" {
  source = "../../../../modules/vpc-peering"

  providers = {
    aws      = aws
    aws.peer = aws.eu_central_1
  }

  name               = "${var.project}-${var.environment}-west-central"
  requester_vpc_id   = data.terraform_remote_state.networking_west.outputs.vpc_id
  accepter_vpc_id    = data.terraform_remote_state.networking_central.outputs.vpc_id
  requester_vpc_cidr = data.terraform_remote_state.networking_west.outputs.vpc_cidr
  accepter_vpc_cidr  = data.terraform_remote_state.networking_central.outputs.vpc_cidr

  requester_route_table_ids = concat(
    [data.terraform_remote_state.networking_west.outputs.public_route_table_id],
    data.terraform_remote_state.networking_west.outputs.private_route_table_ids,
    data.terraform_remote_state.networking_west.outputs.data_route_table_ids,
  )

  accepter_route_table_ids = concat(
    [data.terraform_remote_state.networking_central.outputs.public_route_table_id],
    data.terraform_remote_state.networking_central.outputs.private_route_table_ids,
    data.terraform_remote_state.networking_central.outputs.data_route_table_ids,
  )

  tags = local.common_tags
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
