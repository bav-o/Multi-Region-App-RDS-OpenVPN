provider "aws" {
  region = "eu-west-1"
}

module "openvpn" {
  source = "../../"

  name               = "example-vpn"
  ami_id             = "ami-0123456789abcdef0"
  subnet_id          = "subnet-12345678"
  security_group_ids = ["sg-12345678"]
  key_name           = "example-key"
}
