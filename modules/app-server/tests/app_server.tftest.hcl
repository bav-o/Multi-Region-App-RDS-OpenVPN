provider "aws" {
  region = "eu-west-1"
}

variables {
  name               = "test-app"
  ami_id             = "ami-0123456789abcdef0"
  subnet_id          = "subnet-12345678"
  security_group_ids = ["sg-12345678"]
  key_name           = "test-key"
}

run "creates_instance" {
  command = plan

  assert {
    condition     = aws_instance.this.instance_type == "t3.medium"
    error_message = "Default instance type should be t3.medium."
  }

  assert {
    condition     = aws_instance.this.metadata_options[0].http_tokens == "required"
    error_message = "IMDSv2 should be required."
  }
}
