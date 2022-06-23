terraform {
  required_version = "1.2.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.19.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "viniciustrainotti"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "remote-state" {
  bucket        = "tfstate-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  tags = {
    Description = "Stores terraform remote state files"
    ManagedBy   = "Terraform"
    Owner       = "Vinícius Trainotti"
    CreatedAt   = "2022-06-22"
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.remote-state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.remote-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "lock-table" {
  name           = "tflock-${aws_s3_bucket.remote-state.bucket}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "remote_state_bucket" {
  value = aws_s3_bucket.remote-state.bucket
}

output "remote_state_bucket_arn" {
  value = aws_s3_bucket.remote-state.arn
}

output "remote_state_dynamodb" {
  value = aws_dynamodb_table.lock-table.name
}