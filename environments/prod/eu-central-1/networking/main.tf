provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../../../modules/vpc"

  name            = "${var.project}-${var.environment}-${var.region}"
  cidr            = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  data_subnets    = var.data_subnets
  tags            = local.common_tags
}

module "sg_openvpn" {
  source = "../../../../modules/security-group"

  name        = "${var.project}-${var.environment}-openvpn"
  description = "OpenVPN server security group"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "OpenVPN UDP"
      from_port   = 1194
      to_port     = 1194
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS for web UI"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "SSH from admin"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.admin_cidr_blocks
    }
  ]

  egress_rules = [
    {
      description = "HTTPS outbound"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "DNS UDP"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "DNS TCP"
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "OpenVPN UDP"
      from_port   = 1194
      to_port     = 1194
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Private subnets"
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = var.private_subnets
    }
  ]

  tags = local.common_tags
}

module "sg_app" {
  source = "../../../../modules/security-group"

  name        = "${var.project}-${var.environment}-app"
  description = "Application server security group"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description              = "HTTPS from VPN"
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = module.sg_openvpn.security_group_id
    },
    {
      description              = "App port from VPN"
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      source_security_group_id = module.sg_openvpn.security_group_id
    },
    {
      description              = "SSH from VPN"
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      source_security_group_id = module.sg_openvpn.security_group_id
    },
    {
      description              = "App port from ALB"
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      source_security_group_id = module.sg_alb.security_group_id
    }
  ]

  egress_rules = [
    {
      description = "PostgreSQL to eu-west-1 RDS subnets"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = var.peer_rds_subnet_cidrs
    },
    {
      description = "HTTPS outbound"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = local.common_tags
}

module "sg_rds" {
  source = "../../../../modules/security-group"

  name        = "${var.project}-${var.environment}-rds"
  description = "RDS PostgreSQL security group (DR-ready)"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description              = "PostgreSQL from app"
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = module.sg_app.security_group_id
    }
  ]

  egress_rules = []

  tags = local.common_tags
}

module "sg_alb" {
  source = "../../../../modules/security-group"

  name        = "${var.project}-${var.environment}-alb"
  description = "Application Load Balancer security group"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description              = "HTTPS from VPN"
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = module.sg_openvpn.security_group_id
    },
    {
      description              = "HTTP from VPN"
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = module.sg_openvpn.security_group_id
    }
  ]

  egress_rules = [
    {
      description                   = "To app targets"
      from_port                     = 8080
      to_port                       = 8080
      protocol                      = "tcp"
      destination_security_group_id = module.sg_app.security_group_id
    }
  ]

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
