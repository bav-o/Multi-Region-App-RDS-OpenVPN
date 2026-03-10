provider "aws" {
  region = "eu-west-1"
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

data "terraform_remote_state" "openvpn_west" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "prod/eu-west-1/openvpn/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "openvpn_central" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "prod/eu-central-1/openvpn/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "app_west" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "prod/eu-west-1/app/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "app_central" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "prod/eu-central-1/app/terraform.tfstate"
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

module "public_dns" {
  source = "../../../../modules/dns"

  domain_name = var.public_domain
  is_private  = false

  health_checks = [
    {
      name       = "vpn-west-health"
      ip_address = data.terraform_remote_state.openvpn_west.outputs.public_ip
      port       = 443
      type       = "HTTPS"
    },
    {
      name       = "vpn-central-health"
      ip_address = data.terraform_remote_state.openvpn_central.outputs.public_ip
      port       = 443
      type       = "HTTPS"
    }
  ]

  records = [
    {
      name   = "vpn-west"
      type   = "A"
      ttl    = 300
      values = [data.terraform_remote_state.openvpn_west.outputs.public_ip]
    },
    {
      name   = "vpn-central"
      type   = "A"
      ttl    = 300
      values = [data.terraform_remote_state.openvpn_central.outputs.public_ip]
    }
  ]

  tags = local.common_tags
}

module "private_dns" {
  source = "../../../../modules/dns"

  domain_name = var.private_domain
  is_private  = true

  vpc_associations = [
    {
      vpc_id     = data.terraform_remote_state.networking_west.outputs.vpc_id
      vpc_region = "eu-west-1"
    },
    {
      vpc_id     = data.terraform_remote_state.networking_central.outputs.vpc_id
      vpc_region = "eu-central-1"
    }
  ]

  records = [
    {
      name   = "app"
      type   = "CNAME"
      ttl    = 60
      values = [data.terraform_remote_state.app_west.outputs.alb_dns_name]
    },
    {
      name   = "app-west"
      type   = "CNAME"
      ttl    = 300
      values = [data.terraform_remote_state.app_west.outputs.alb_dns_name]
    },
    {
      name   = "app-central"
      type   = "CNAME"
      ttl    = 300
      values = [data.terraform_remote_state.app_central.outputs.alb_dns_name]
    },
    {
      name   = "db"
      type   = "CNAME"
      ttl    = 300
      values = [data.terraform_remote_state.database.outputs.db_address]
    }
  ]

  tags = local.common_tags
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
