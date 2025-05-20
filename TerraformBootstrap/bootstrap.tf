# Create a bootstrap Terraform configuration to create an S3 bucket for state storage and a DynamoDB table for state locking.

provider "aws" {
  profile = "private"
  region  = "us-west-2"
}

# Create a random ID
resource "random_id" "suffix" {
  byte_length = 4
}

# S3 bucket for state
resource "aws_s3_bucket" "state" {
  bucket = "assignment-webapp-terraform-state-bucket-${random_id.suffix.hex}"  # Unique bucket name with random ID
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "lock" {
  name         = "assignment-webapp-terraform-state-lock-table-${random_id.suffix.hex}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
