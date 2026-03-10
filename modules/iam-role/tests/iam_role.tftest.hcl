provider "aws" {
  region = "eu-west-1"
}

run "creates_iam_role" {
  command = plan

  variables {
    name = "test-iam-role"
    tags = {
      Environment = "test"
    }
  }

  assert {
    condition     = aws_iam_role.this.name == "test-iam-role"
    error_message = "IAM role name does not match"
  }

  assert {
    condition     = aws_iam_instance_profile.this.name == "test-iam-role"
    error_message = "Instance profile name does not match"
  }
}
