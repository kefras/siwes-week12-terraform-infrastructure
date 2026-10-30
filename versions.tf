
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "siwes-terraform"

  default_tags {
    tags = {
      Project     = "SIWES-Week12-Project1"
      Environment = "lab"
      ManagedBy   = "Terraform"
    }
  }
}
