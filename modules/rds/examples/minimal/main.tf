provider "aws" {
  region = "eu-west-1"
}

module "rds" {
  source = "../../"

  name               = "example-db"
  db_name            = "exampledb"
  subnet_ids         = ["subnet-12345678", "subnet-87654321"]
  security_group_ids = ["sg-12345678"]
}
