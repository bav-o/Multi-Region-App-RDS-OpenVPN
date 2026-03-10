provider "aws" {
  region = "eu-west-1"
}

variables {
  name               = "test-vpn"
  ami_id             = "ami-0123456789abcdef0"
  subnet_id          = "subnet-12345678"
  security_group_ids = ["sg-12345678"]
  key_name           = "test-key"
}

run "creates_instance" {
  command = plan

  assert {
    condition     = aws_instance.this.instance_type == "t3.small"
    error_message = "Default instance type should be t3.small."
  }
}

run "creates_eip" {
  command = plan

  assert {
    condition     = aws_eip.this.domain == "vpc"
    error_message = "EIP should be in VPC domain."
  }
}
