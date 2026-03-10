# VPC

Creates a VPC with public, private, and data subnets, NAT gateways, an internet gateway, and optional VPC flow logs.

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  name            = "main"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  data_subnets    = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  enable_flow_logs        = true
  flow_logs_retention_days = 30

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| name | `string` | - | yes | Name prefix for all resources |
| cidr | `string` | - | yes | CIDR block for the VPC |
| azs | `list(string)` | - | yes | Availability zones |
| public_subnets | `list(string)` | - | yes | CIDR blocks for public subnets |
| private_subnets | `list(string)` | - | yes | CIDR blocks for private subnets |
| data_subnets | `list(string)` | `[]` | no | CIDR blocks for data subnets |
| tags | `map(string)` | `{}` | no | Tags to apply to all resources |
| enable_flow_logs | `bool` | `true` | no | Enable VPC flow logs |
| flow_logs_retention_days | `number` | `30` | no | CloudWatch log group retention in days |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_cidr | CIDR block of the VPC |
| public_subnet_ids | List of public subnet IDs |
| private_subnet_ids | List of private subnet IDs |
| data_subnet_ids | List of data subnet IDs |
| public_route_table_id | ID of the public route table |
| private_route_table_ids | List of private route table IDs |
| nat_gateway_ids | List of NAT gateway IDs |
| igw_id | ID of the internet gateway |
