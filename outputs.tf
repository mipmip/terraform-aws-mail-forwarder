#output "ses_domain_identity_arn" {
#  description = "The ARN of the domain identity"
#  value       = aws_ses_domain_identity.default.arn
#}
#
#output "ses_domain_identity_verification_arn" {
#  description = "The ARN of the domain identity"
#  value       = aws_ses_domain_identity_verification.default.arn
#}

output "s3_bucket_id" {
  description = "Lamnda IAM Policy name"
  value       = aws_s3_bucket.default.id
}

output "s3_bucket_arn" {
  description = "Lamnda IAM Policy ARN"
  value       = aws_s3_bucket.default.arn
}

output "s3_bucket_domain_name" {
  description = "Lamnda IAM Policy ARN"
  value       = aws_s3_bucket.default.bucket_domain_name
}

output "ses_receipt_rule_name" {
  description = "The name of the SES receipt rule"
  value       = aws_ses_receipt_rule.default.name
}

output "ses_receipt_rule_set_name" {
  description = "The name of the SES receipt rule set"
  value       = aws_ses_receipt_rule.default.rule_set_name
}
