provider "aws" {
    region = var.default_region
}

resource "aws_s3_bucket" "bucket_s3" {
    bucket = "host-static-web-app-s3-cloudfront"
    provider = aws
    region = var.default_region
    tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "s3_access" {
    bucket = aws_s3_bucket.bucket_s3.id
    provider = aws
    region = var.default_region
}

resource "aws_s3_bucket_versioning" "version_s3" {
    bucket = aws_s3_bucket.bucket_s3.id
    provider = aws
    region = var.default_region
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_s3" {
    bucket = aws_s3_bucket.bucket_s3.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
    provider = aws
    region = var.default_region
}
