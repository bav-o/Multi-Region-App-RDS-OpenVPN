provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source = "../../"

  name            = "example-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
  data_subnets    = ["10.0.20.0/24", "10.0.21.0/24"]
}
