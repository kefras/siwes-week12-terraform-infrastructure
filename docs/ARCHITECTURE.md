# Architecture and resource boundaries

## Lab-managed resources

- `aws_s3_bucket.website`: private lab bucket
- `aws_s3_bucket_public_access_block.website`: block all public-access options
- `aws_s3_bucket_server_side_encryption_configuration.website`: AES256 default encryption
- `aws_cloudfront_origin_access_control.website`: lab OAC (not currently attached to a serving distribution)
- `aws_iam_role.lambda_execution`: Lambda service trust role
- `aws_iam_role_policy_attachment.lambda_logs`: AWS-managed basic execution/logging policy

## Referenced external resource

- `data.aws_cloudfront_distribution.existing`: pre-existing distribution for the separate portfolio. Terraform reads its properties; this project does not own its lifecycle.

## S3 remote state

Terraform is configured to use an existing S3 state bucket with S3 lockfile support. The state backend is distinct from the lab website bucket. Protect state access because it may contain sensitive infrastructure metadata.

## Not deployed

- A dedicated CloudFront distribution serving the SIWES bucket
- A corresponding CloudFront-restricted S3 bucket policy for a dedicated lab distribution
- A Lambda function or API

## Deployment boundary

Never change the existing portfolio distribution's default origin or behavior as part of this lab without an explicit change plan, backup, and rollback procedure.
