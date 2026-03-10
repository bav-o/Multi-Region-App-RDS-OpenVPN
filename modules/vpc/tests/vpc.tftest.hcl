provider "aws" {
  region = "eu-west-1"
}

variables {
  name            = "test-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
  data_subnets    = ["10.0.20.0/24", "10.0.21.0/24"]
}

run "creates_vpc" {
  command = plan

  assert {
    condition     = aws_vpc.this.cidr_block == "10.0.0.0/16"
    error_message = "VPC CIDR block does not match expected value."
  }
}

run "creates_public_subnets" {
  command = plan

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Expected 2 public subnets."
  }
}

run "creates_private_subnets" {
  command = plan

  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "Expected 2 private subnets."
  }
}

run "creates_data_subnets" {
  command = plan

  assert {
    condition     = length(aws_subnet.data) == 2
    error_message = "Expected 2 data subnets."
  }
}

run "creates_nat_gateways" {
  command = plan

  assert {
    condition     = length(aws_nat_gateway.this) == 2
    error_message = "Expected 2 NAT gateways."
  }
}
