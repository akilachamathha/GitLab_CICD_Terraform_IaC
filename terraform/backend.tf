# Configures the backend for terraform state files.
terraform {
  backend "s3" {
    bucket ="assignment-webapp-terraform-state-bucket-b081ff19"    # State store S3 bucket name
    key    = "state"  # S3 bucket object name
    region =    "us-west-2"
    # profile = "private"   # profile name for AWS CLI. Commented out for Gitlab pipeline
    dynamodb_table = "assignment-webapp-terraform-state-lock-table-b081ff19"    # DynamoDB table for state locking
  }
}