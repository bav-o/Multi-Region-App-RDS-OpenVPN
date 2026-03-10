# VPC Peering

Creates a VPC peering connection between two VPCs and configures route propagation in both directions. Requires an `aws.peer` provider alias for the accepter side.

## Usage

```hcl
module "peering" {
  source = "./modules/vpc-peering"

  providers = {
    aws.peer = aws.us-west-2
  }

  name                    = "main-to-dr"
  requester_vpc_id        = module.vpc_main.vpc_id
  accepter_vpc_id         = module.vpc_dr.vpc_id
  requester_vpc_cidr      = module.vpc_main.vpc_cidr
  accepter_vpc_cidr       = module.vpc_dr.vpc_cidr
  requester_route_table_ids = module.vpc_main.private_route_table_ids
  accepter_route_table_ids  = module.vpc_dr.private_route_table_ids

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| name | `string` | - | yes | Name tag for the peering connection |
| requester_vpc_id | `string` | - | yes | ID of the requester VPC |
| accepter_vpc_id | `string` | - | yes | ID of the accepter VPC |
| requester_vpc_cidr | `string` | - | yes | CIDR block of the requester VPC |
| accepter_vpc_cidr | `string` | - | yes | CIDR block of the accepter VPC |
| requester_route_table_ids | `list(string)` | - | yes | Route table IDs in the requester VPC to add routes to |
| accepter_route_table_ids | `list(string)` | - | yes | Route table IDs in the accepter VPC to add routes to |
| tags | `map(string)` | `{}` | no | Tags to apply to the peering connection |

## Outputs

| Name | Description |
|------|-------------|
| peering_connection_id | ID of the VPC peering connection |
| peering_connection_status | Status of the peering connection |
