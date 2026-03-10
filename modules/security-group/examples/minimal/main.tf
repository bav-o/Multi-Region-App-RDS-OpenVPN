provider "aws" {
  region = "eu-west-1"
}

module "sg" {
  source = "../../"

  name        = "example-sg"
  description = "Example security group"
  vpc_id      = "vpc-12345678"

  ingress_rules = [
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]
}
