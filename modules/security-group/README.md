# Security Group

Creates a security group with configurable ingress and egress rules.

## Usage

```hcl
module "app_sg" {
  source = "./modules/security-group"

  name        = "app-server"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    }
  ]

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| name | `string` | - | yes | Name of the security group |
| description | `string` | - | yes | Description of the security group |
| vpc_id | `string` | - | yes | ID of the VPC |
| ingress_rules | `list(object)` | `[]` | no | List of ingress rule objects |
| egress_rules | `list(object)` | Allow all outbound | no | List of egress rule objects |
| tags | `map(string)` | `{}` | no | Tags to apply to the security group |

## Outputs

| Name | Description |
|------|-------------|
| security_group_id | ID of the security group |
| security_group_arn | ARN of the security group |
