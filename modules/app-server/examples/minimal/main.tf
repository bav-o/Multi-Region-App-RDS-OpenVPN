provider "aws" {
  region = "eu-west-1"
}

module "app_server" {
  source = "../../"

  name               = "example-app"
  ami_id             = "ami-0123456789abcdef0"
  subnet_id          = "subnet-12345678"
  security_group_ids = ["sg-12345678"]
  key_name           = "example-key"
}
