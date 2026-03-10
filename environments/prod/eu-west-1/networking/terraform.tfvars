region          = "eu-west-1"
project         = "myproject"
environment     = "prod"
vpc_cidr        = "10.10.0.0/16"
azs             = ["eu-west-1a", "eu-west-1b"]
public_subnets  = ["10.10.1.0/24", "10.10.2.0/24"]
private_subnets = ["10.10.10.0/24", "10.10.11.0/24"]
data_subnets    = ["10.10.20.0/24", "10.10.21.0/24"]
# REPLACE WITH YOUR ADMIN IP BEFORE DEPLOYING
admin_cidr_blocks     = ["203.0.113.0/32"]
peer_app_subnet_cidrs = ["10.20.10.0/24", "10.20.11.0/24"]
