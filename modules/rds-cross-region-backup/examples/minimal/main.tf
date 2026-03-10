provider "aws" {
  region = "eu-central-1"
}

module "backup" {
  source = "../../"

  name                   = "example-backup"
  source_db_instance_arn = "arn:aws:rds:eu-west-1:123456789012:db:example-db"
  kms_key_arn            = "arn:aws:kms:eu-central-1:123456789012:key/example-key-id"
}
