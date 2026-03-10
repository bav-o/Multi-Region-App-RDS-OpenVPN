provider "aws" {
  region = "eu-west-1"
}

variables {
  name               = "test-db"
  db_name            = "testdb"
  subnet_ids         = ["subnet-12345678", "subnet-87654321"]
  security_group_ids = ["sg-12345678"]
}

run "creates_rds_instance" {
  command = plan

  assert {
    condition     = aws_db_instance.this.engine == "postgres"
    error_message = "Engine should be postgres."
  }

  assert {
    condition     = aws_db_instance.this.deletion_protection == true
    error_message = "Deletion protection should be enabled."
  }

  assert {
    condition     = aws_db_instance.this.storage_encrypted == true
    error_message = "Storage encryption should be enabled."
  }
}

run "creates_parameter_group" {
  command = plan

  assert {
    condition     = aws_db_parameter_group.this.family == "postgres16"
    error_message = "Parameter group family should match engine version."
  }
}
