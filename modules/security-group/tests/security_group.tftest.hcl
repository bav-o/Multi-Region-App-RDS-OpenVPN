provider "aws" {
  region = "eu-west-1"
}

variables {
  name        = "test-sg"
  description = "Test security group"
  vpc_id      = "vpc-12345678"

  ingress_rules = [
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    },
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]
}

run "creates_security_group" {
  command = plan

  assert {
    condition     = aws_security_group.this.name == "test-sg"
    error_message = "Security group name does not match."
  }

  assert {
    condition     = aws_security_group.this.description == "Test security group"
    error_message = "Security group description does not match."
  }
}

run "creates_ingress_rules" {
  command = plan

  assert {
    condition     = length(aws_security_group_rule.ingress) == 2
    error_message = "Expected 2 ingress rules."
  }
}
