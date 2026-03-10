output "zone_id" {
  description = "The ID of the Route 53 hosted zone"
  value       = aws_route53_zone.this.zone_id
}

output "zone_name_servers" {
  description = "The name servers for the hosted zone"
  value       = aws_route53_zone.this.name_servers
}

output "zone_arn" {
  description = "The ARN of the Route 53 hosted zone"
  value       = aws_route53_zone.this.arn
}

output "health_check_ids" {
  description = "Map of health check name to ID"
  value       = { for k, v in aws_route53_health_check.health_check : k => v.id }
}
