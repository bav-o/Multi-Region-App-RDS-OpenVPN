output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "ALB Route 53 zone ID"
  value       = module.alb.alb_zone_id
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.asg.asg_name
}

output "db_endpoint" {
  description = "Database endpoint"
  value       = data.terraform_remote_state.database.outputs.db_endpoint
}

output "sns_topic_arn" {
  description = "Monitoring alerts SNS topic ARN"
  value       = module.monitoring.sns_topic_arn
}
