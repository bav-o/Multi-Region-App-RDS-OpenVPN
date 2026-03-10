output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for az in var.azs : aws_subnet.public[az].id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for az in var.azs : aws_subnet.private[az].id]
}

output "data_subnet_ids" {
  description = "List of data subnet IDs"
  value       = [for az in var.azs : aws_subnet.data[az].id if contains(keys(aws_subnet.data), az)]
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = [for az in var.azs : aws_route_table.private[az].id]
}

output "nat_gateway_ids" {
  description = "List of NAT gateway IDs"
  value       = [for az in var.azs : aws_nat_gateway.nat[az].id]
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "data_route_table_ids" {
  description = "List of data route table IDs"
  value       = aws_route_table.data[*].id
}
