# Create the aws provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
  # profile = var.profile      # profile name for AWS CLI. Commented out for Gitlab pipeline
}

# Get the current AWS account
data "aws_caller_identity" "current" {} 