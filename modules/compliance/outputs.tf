output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = aws_cloudtrail.this.arn
}

output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector"
  value       = aws_guardduty_detector.this.id
}

output "cloudtrail_bucket_id" {
  description = "ID of the CloudTrail S3 bucket"
  value       = aws_s3_bucket.cloudtrail.id
}
