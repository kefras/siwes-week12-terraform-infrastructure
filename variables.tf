
variable "aws_region" {
  description = "AWS region for lab resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "Unique S3 bucket for the lab website"
  type        = string
}

variable "project_name" {
  description = "Project identifier"
  type        = string
  default     = "siwes-project1-rebuild"
}
