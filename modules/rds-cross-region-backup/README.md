# RDS Cross-Region Backup

Sets up automated cross-region backup replication for an RDS instance.

## Usage

```hcl
module "dr_backup" {
  source = "./modules/rds-cross-region-backup"

  name                    = "myapp-db-dr"
  source_db_instance_arn  = module.database.db_instance_arn
  kms_key_arn             = aws_kms_key.dr.arn
  retention_period        = 14

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| name | `string` | - | yes | Name for the backup replication resource |
| source_db_instance_arn | `string` | - | yes | ARN of the source RDS instance |
| kms_key_arn | `string` | - | yes | KMS key ARN in the destination region for encrypting backups |
| retention_period | `number` | `14` | no | Days to retain replicated backups |
| tags | `map(string)` | `{}` | no | Tags to apply to resources |

## Outputs

| Name | Description |
|------|-------------|
| replication_id | ID of the backup replication configuration |
