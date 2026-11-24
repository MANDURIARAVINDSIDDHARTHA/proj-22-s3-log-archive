terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "logs" {
  bucket = var.bucket_name
  tags   = { Name = "proj22-log-archive" }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "log_files" {
  for_each = fileset("${path.module}/logs", "*.log")

  bucket = aws_s3_bucket.logs.id
  key    = "logs/${each.value}"
  source = "${path.module}/logs/${each.value}"
  etag   = filemd5("${path.module}/logs/${each.value}")
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "expire-logs-after-30-days"
    status = "Enabled"

    filter {
      prefix = "logs/"
    }

    expiration {
      days = var.expiration_days
    }
  }
}
