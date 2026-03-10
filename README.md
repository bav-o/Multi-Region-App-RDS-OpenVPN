# Terraform Infrastructure

Multi-region AWS infrastructure managed with Terraform. Covers networking, compute, database, DNS, VPN, compliance, monitoring, and WAF across `eu-west-1` and `eu-central-1`.

## Project Structure

```
.
├── bootstrap/                          # Remote state backend (S3 + DynamoDB + cross-region replica)
├── environments/
│   └── prod/
│       ├── eu-west-1/
│       │   ├── networking/            # Primary region VPC, security groups (incl. ALB SG)
│       │   ├── app/                   # ALB + ASG + WAF + Monitoring
│       │   ├── openvpn/               # OpenVPN with IAM instance profile
│       │   └── database/              # RDS PostgreSQL (primary)
│       ├── eu-central-1/
│       │   ├── networking/            # Secondary region VPC, security groups, data subnets
│       │   ├── app/                   # ALB + ASG + WAF + Monitoring
│       │   ├── openvpn/               # OpenVPN with IAM instance profile
│       │   └── database/              # DR-ready (DB subnet group only)
│       └── global/
│           ├── vpc-peering/           # Cross-region VPC peering
│           ├── dns/                   # Route 53 with health checks
│           ├── rds-backup/            # Cross-region RDS backup replication
│           └── compliance/            # CloudTrail, GuardDuty, AWS Config
└── modules/
    ├── vpc/                            # VPC with public/private/data subnets, NAT, flow logs
    ├── security-group/                 # Security group with composite for_each keys
    ├── alb/                            # Internal ALB with HTTPS/HTTP listeners
    ├── asg/                            # Auto Scaling Group with launch template (IMDSv2, gp3)
    ├── iam-role/                       # EC2 IAM role with SSM and configurable policies
    ├── app-server/                     # EC2 application instance (legacy, replaced by ALB+ASG)
    ├── openvpn/                        # OpenVPN instance with Elastic IP
    ├── rds/                            # RDS PostgreSQL — encrypted, multi-AZ, managed passwords
    ├── rds-cross-region-backup/        # Cross-region automated backup replication
    ├── vpc-peering/                    # VPC peering with bidirectional route propagation
    ├── dns/                            # Route 53 with health checks and failover routing
    ├── compliance/                     # CloudTrail, AWS Config, GuardDuty
    ├── monitoring/                     # SNS + CloudWatch alarms (ALB, RDS, EC2)
    └── waf/                            # WAFv2 web ACL with AWS managed rule sets
```

## Prerequisites

- Terraform `~> 1.5`
- AWS CLI configured with appropriate credentials
- AWS provider `~> 5.0`

## Getting Started

### 1. Bootstrap Remote State

Run once to create the S3 bucket (with cross-region replica), DynamoDB table, and replication IAM role:

```bash
cd bootstrap
terraform init
terraform apply -var="org_name=myorg"
```

> Bootstrap uses local state by design — it creates the backend that all other configurations use.

### 2. Deploy Networking

```bash
cd environments/prod/eu-west-1/networking
terraform init
terraform apply
```

Repeat for `eu-central-1`.

### 3. Deploy Compliance

```bash
cd environments/prod/global/compliance
terraform init
terraform apply
```

### 4. Deploy Compute + Database

Deploy VPC peering, then database, OpenVPN, and app layers (ALB+ASG+WAF) in each region.

## Modules

| Module | Description |
|--------|-------------|
| [vpc](modules/vpc/) | VPC with public, private, and isolated data subnets, NAT gateways, VPC flow logs |
| [security-group](modules/security-group/) | Security group with composite for_each keys for stable addressing |
| [alb](modules/alb/) | Internal ALB with target group, HTTPS/HTTP listeners, TLS 1.3 policy |
| [asg](modules/asg/) | Launch template (IMDSv2, encrypted gp3) with ASG and CPU target tracking |
| [iam-role](modules/iam-role/) | EC2 IAM role with SSM managed policy and configurable additional policies |
| [app-server](modules/app-server/) | EC2 instance with encrypted root volume and IMDSv2 enforced |
| [openvpn](modules/openvpn/) | OpenVPN EC2 instance with Elastic IP |
| [rds](modules/rds/) | RDS PostgreSQL — KMS encrypted, multi-AZ, managed master password, storage autoscaling |
| [rds-cross-region-backup](modules/rds-cross-region-backup/) | Cross-region automated backup replication for RDS |
| [vpc-peering](modules/vpc-peering/) | VPC peering connection with bidirectional route propagation |
| [dns](modules/dns/) | Route 53 hosted zone with health checks and failover routing support |
| [compliance](modules/compliance/) | CloudTrail (multi-region), AWS Config recorder, GuardDuty detector |
| [monitoring](modules/monitoring/) | SNS topic + CloudWatch alarms for ALB 5XX, RDS CPU/memory/connections |
| [waf](modules/waf/) | WAFv2 web ACL with Common, SQLi, and Bad Inputs managed rule sets |

## Running Tests

```bash
cd modules/vpc
terraform init
terraform test
```

## Conventions

- All resources use `for_each` over `count` for stable addressing
- Required variables are marked `nullable = false`
- Key variables include `validation` blocks
- Terraform version pinned to `~> 1.5` across all configurations
- Production data resources (RDS, S3 state bucket, KMS keys) have `prevent_destroy = true`

## Known Limitations

- **2 Availability Zones**: The architecture currently uses 2 AZs per region. For higher fault tolerance, expand to 3 AZs by adding additional subnet CIDRs.
- **Single-AZ OpenVPN**: OpenVPN instances are placed in the first public subnet only. VPN is a single point of entry by design.
- **Duplicated tags**: Common tags are defined as `locals` in each environment layer rather than inherited from a shared module. This is by design to keep layers fully independent, but means tag changes must be applied in each layer.
- **Burstable instances**: Default instance types (`t3.medium`, `t3.small`, `db.t3.medium`) are burstable and subject to CPU credit throttling under sustained load. Use compute-optimized or memory-optimized instances for production workloads.
- **DR is warm standby**: eu-central-1 has DB subnet group and security group provisioned but no live RDS instance. Restore from cross-region backup on demand.
