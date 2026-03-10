provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "peer"
  region = "eu-central-1"
}

module "peering" {
  source = "../../"

  providers = {
    aws      = aws
    aws.peer = aws.peer
  }

  name                      = "example-peering"
  requester_vpc_id          = "vpc-11111111"
  accepter_vpc_id           = "vpc-22222222"
  requester_vpc_cidr        = "10.0.0.0/16"
  accepter_vpc_cidr         = "10.1.0.0/16"
  requester_route_table_ids = ["rtb-11111111"]
  accepter_route_table_ids  = ["rtb-22222222"]
}
