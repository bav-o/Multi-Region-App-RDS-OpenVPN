# App Server

Creates an EC2 instance for application workloads.

## Usage

```hcl
module "app" {
  source = "./modules/app-server"

  name               = "web-app"
  ami_id             = "ami-0abcdef1234567890"
  instance_type      = "t3.medium"
  subnet_id          = module.vpc.private_subnet_ids[0]
  security_group_ids = [module.app_sg.security_group_id]
  key_name           = "my-key"

  iam_instance_profile = aws_iam_instance_profile.app.name

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| name | `string` | - | yes | Name tag for the instance |
| ami_id | `string` | - | yes | AMI ID for the instance |
| instance_type | `string` | `"t3.medium"` | no | EC2 instance type |
| subnet_id | `string` | - | yes | Subnet ID to launch the instance in |
| security_group_ids | `list(string)` | - | yes | List of security group IDs |
| key_name | `string` | - | yes | SSH key pair name |
| iam_instance_profile | `string` | `null` | no | IAM instance profile name |
| tags | `map(string)` | `{}` | no | Tags to apply to the instance |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the EC2 instance |
| private_ip | Private IP address of the instance |
