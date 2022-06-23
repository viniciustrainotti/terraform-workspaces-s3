data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "storage-example" {
  bucket        = "tfstate-${data.aws_caller_identity.current.account_id}-${terraform.workspace}"
  force_destroy = true

  tags = {
    Description = "S3 workspaces tests"
    ManagedBy   = "Terraform"
    Owner       = "Vinícius Trainotti"
    CreatedAt   = "2022-06-22"
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.storage-example.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.storage-example.id
  versioning_configuration {
    status = "Enabled"
  }
}