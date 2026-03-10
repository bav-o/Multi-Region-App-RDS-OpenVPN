provider "aws" {
  region = "eu-west-1"
}

module "dns" {
  source = "../../"

  domain_name = "example.internal"

  records = [
    {
      name   = "app"
      type   = "A"
      values = ["10.0.1.10"]
    }
  ]
}
