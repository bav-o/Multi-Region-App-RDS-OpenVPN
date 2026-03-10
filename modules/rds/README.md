# RDS

Creates an RDS PostgreSQL instance with encryption, a custom parameter group, and automated backups. Master credentials are managed via AWS Secrets Manager.

## Usage

```hcl
module "database" {
  source = "./modules/rds"

  name            = "myapp-db"
  engine_version  = "16.4"
  instance_class  = "db.t3.medium"
  db_name         = "myapp"

  allocated_storage     = 50
  max_allocated_storage = 200

  subnet_ids         = module.vpc.data_subnet_ids
  security_group_ids = [module.db_sg.security_group_id]

  multi_az                = true
  backup_retention_period = 14
  kms_key_arn             = aws_kms_key.rds.arn

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| name | `string` | - | yes | Identifier for the RDS instance |
| engine_version | `string` | `"16.4"` | no | PostgreSQL engine version |
| instance_class | `string` | `"db.t3.medium"` | no | RDS instance class |
| allocated_storage | `number` | `50` | no | Allocated storage in GB |
| max_allocated_storage | `number` | `200` | no | Max storage for autoscaling in GB |
| db_name | `string` | - | yes | Name of the default database |
| subnet_ids | `list(string)` | - | yes | Subnet IDs for the DB subnet group |
| security_group_ids | `list(string)` | - | yes | Security group IDs for the instance |
| multi_az | `bool` | `true` | no | Enable Multi-AZ deployment |
| backup_retention_period | `number` | `14` | no | Days to retain automated backups |
| kms_key_arn | `string` | `null` | no | KMS key ARN for encryption (uses AWS managed key if null) |
| tags | `map(string)` | `{}` | no | Tags to apply to all resources |

## Outputs

| Name | Description |
|------|-------------|
| db_instance_id | Identifier of the RDS instance |
| db_instance_arn | ARN of the RDS instance |
| db_endpoint | Connection endpoint (host:port) |
| db_address | Hostname of the RDS instance |
| db_port | Port of the RDS instance |
| db_name | Name of the default database |
| kms_key_arn | ARN of the KMS key used for encryption |
| master_user_secret_arn | ARN of the Secrets Manager secret for master credentials |
