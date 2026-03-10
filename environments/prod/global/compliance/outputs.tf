output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = module.compliance.cloudtrail_arn
}

output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector"
  value       = module.compliance.guardduty_detector_id
}
