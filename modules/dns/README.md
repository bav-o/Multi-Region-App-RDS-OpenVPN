# DNS

Creates a Route 53 hosted zone (public or private) and manages DNS records within it.

## Usage

```hcl
module "dns" {
  source = "./modules/dns"

  domain_name = "example.com"
  is_private  = false

  records = [
    {
      name    = "app"
      type    = "A"
      ttl     = 300
      records = ["10.0.1.100"]
    },
    {
      name    = "api"
      type    = "CNAME"
      ttl     = 300
      records = ["app.example.com"]
    }
  ]

  tags = {
    Environment = "production"
  }
}
```

For a private hosted zone:

```hcl
module "internal_dns" {
  source = "./modules/dns"

  domain_name = "internal.example.com"
  is_private  = true

  vpc_associations = [
    { vpc_id = module.vpc.vpc_id, vpc_region = "us-east-1" }
  ]

  records = [
    {
      name    = "db"
      type    = "CNAME"
      ttl     = 60
      records = [module.database.db_address]
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
| domain_name | `string` | - | yes | Domain name for the hosted zone |
| is_private | `bool` | `false` | no | Whether this is a private hosted zone |
| vpc_associations | `list(object)` | `[]` | no | VPCs to associate with a private zone (vpc_id, vpc_region) |
| records | `list(object)` | - | yes | List of DNS record objects (name, type, ttl, records) |
| tags | `map(string)` | `{}` | no | Tags to apply to the hosted zone |

## Outputs

| Name | Description |
|------|-------------|
| zone_id | ID of the Route 53 hosted zone |
| zone_name_servers | Name servers for the hosted zone |
| zone_arn | ARN of the hosted zone |
