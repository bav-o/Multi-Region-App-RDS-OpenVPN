output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = module.vpc.public_route_table_id
}

output "private_route_table_ids" {
  description = "Private route table IDs"
  value       = module.vpc.private_route_table_ids
}

output "sg_openvpn_id" {
  description = "OpenVPN security group ID"
  value       = module.sg_openvpn.security_group_id
}

output "sg_app_id" {
  description = "App security group ID"
  value       = module.sg_app.security_group_id
}

output "data_subnet_ids" {
  description = "Data subnet IDs"
  value       = module.vpc.data_subnet_ids
}

output "data_route_table_ids" {
  description = "Data route table IDs"
  value       = module.vpc.data_route_table_ids
}

output "sg_rds_id" {
  description = "RDS security group ID"
  value       = module.sg_rds.security_group_id
}

output "sg_alb_id" {
  description = "ALB security group ID"
  value       = module.sg_alb.security_group_id
}
