# OpenVPN

Creates an OpenVPN EC2 instance with an associated Elastic IP.

## Usage

```hcl
module "vpn" {
  source = "./modules/openvpn"

  name               = "openvpn"
  ami_id             = "ami-0abcdef1234567890"
  instance_type      = "t3.small"
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.vpn_sg.security_group_id]
  key_name           = "my-key"

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| name | `string` | - | yes | Name tag for the instance and EIP |
| ami_id | `string` | - | yes | AMI ID for the OpenVPN instance |
| instance_type | `string` | `"t3.small"` | no | EC2 instance type |
| subnet_id | `string` | - | yes | Public subnet ID to launch the instance in |
| security_group_ids | `list(string)` | - | yes | List of security group IDs |
| key_name | `string` | - | yes | SSH key pair name |
| iam_instance_profile | `string` | `null` | no | IAM instance profile name |
| tags | `map(string)` | `{}` | no | Tags to apply to resources |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the EC2 instance |
| public_ip | Elastic IP address |
| eip_id | ID of the Elastic IP allocation |
