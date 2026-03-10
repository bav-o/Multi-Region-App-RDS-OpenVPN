provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "peer"
  region = "eu-central-1"
}

variables {
  name                      = "test-peering"
  requester_vpc_id          = "vpc-11111111"
  accepter_vpc_id           = "vpc-22222222"
  requester_vpc_cidr        = "10.0.0.0/16"
  accepter_vpc_cidr         = "10.1.0.0/16"
  requester_route_table_ids = ["rtb-11111111"]
  accepter_route_table_ids  = ["rtb-22222222"]
}

run "creates_peering_connection" {
  command = plan

  assert {
    condition     = aws_vpc_peering_connection.this.auto_accept == false
    error_message = "Auto accept should be false on requester side."
  }
}

run "creates_routes" {
  command = plan

  assert {
    condition     = length(aws_route.requester) == 1
    error_message = "Expected 1 requester route."
  }

  assert {
    condition     = length(aws_route.accepter) == 1
    error_message = "Expected 1 accepter route."
  }
}
