
# --------------------------------------------------
# Week 12 Task 12.2
# Terraform Infrastructure Outputs
# --------------------------------------------------

output "website_bucket_name" {
  description = "Name of the SIWES lab S3 bucket"
  value       = aws_s3_bucket.website.id
}

output "website_bucket_arn" {
  description = "ARN of the SIWES lab S3 bucket"
  value       = aws_s3_bucket.website.arn
}

output "cloudfront_distribution_id" {
  description = "Existing production CloudFront distribution ID"
  value       = data.aws_cloudfront_distribution.existing.id
}

output "cloudfront_domain_name" {
  description = "Existing production CloudFront domain"
  value       = data.aws_cloudfront_distribution.existing.domain_name
}

output "cloudfront_oac_id" {
  description = "SIWES lab OAC ID (not attached to production)"
  value       = aws_cloudfront_origin_access_control.website.id
}

output "lambda_execution_role_arn" {
  description = "ARN of the Lambda execution IAM role"
  value       = aws_iam_role.lambda_execution.arn
}

output "aws_account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}
