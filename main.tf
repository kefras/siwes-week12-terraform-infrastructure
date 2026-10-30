
# --------------------------------------------------
# Week 12 Task 12.2
# Project 1 Infrastructure Rebuild with Terraform
# Existing CloudFront integration (read-only)
# --------------------------------------------------

data "aws_caller_identity" "current" {}

# 1. Private S3 bucket for SIWES lab
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  tags = {
    Name = "${var.project_name}-${var.environment}"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# 2. Block all public access
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# 3. Enable S3 server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. Existing production CloudFront distribution
# Read-only: Terraform will not create, modify or delete it
data "aws_cloudfront_distribution" "existing" {
  id = "E1HJ5YKDDWW6ZI"
}

# 5. Existing lab CloudFront OAC
# Retained in Terraform state but not attached to
# the production distribution.
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "${var.project_name}-${var.environment}-oac"
  description                       = "OAC for SIWES Project 1 lab"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# 6. Lambda IAM trust policy
data "aws_iam_policy_document" "lambda_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# 7. Lambda execution role
resource "aws_iam_role" "lambda_execution" {
  name               = "${var.project_name}-${var.environment}-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json

  tags = {
    Name = "${var.project_name}-${var.environment}-lambda"
  }
}

# 8. Attach basic Lambda execution permissions
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
