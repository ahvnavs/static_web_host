provider "aws" {
    region = var.default_region
}

resource "aws_s3_bucket" "bucket_s3" {
    bucket = "host-static-web-app-s3-cloudfront-terraform"
    tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "s3_access" {
    bucket = aws_s3_bucket.bucket_s3.id
    block_public_acls = true
    block_public_policy = true
    restrict_public_buckets = true
    ignore_public_acls = true
}

locals {
    content_types = {
        ".html" = "text/html"
        ".css" = "text/css"
        ".js" = "application/javascript"
    }
}

resource "aws_s3_object" "s3_object" {
    bucket = aws_s3_bucket.bucket_s3.id
    for_each = fileset("${path.module}/www", "**/*")
    key = each.value
    source = "${path.module}/www/${each.value}"
    etag = filemd5("${path.module}/www/${each.value}")
    content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), "binary/octet-stream")
}

resource "aws_s3_bucket_policy" "s3_policy" {
    bucket = aws_s3_bucket.bucket_s3.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "cloudfront.amazonaws.com"
                }
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.bucket_s3.arn}/*"
                Condition = {
                    StringEquals = {
                        "AWS:SourceArn" = aws_cloudfront_distribution.edge_distro.arn
                    }
                }
            }
        ]
    })
}

resource "aws_s3_bucket_versioning" "version_s3" {
    bucket = aws_s3_bucket.bucket_s3.id
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
}

resource "aws_cloudfront_origin_access_control" "edge_oac" {
    name = "cloud_edge_oac"
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "edge_distro" {
    enabled = true
    default_root_object = "index.html"
    origin {
        domain_name = aws_s3_bucket.bucket_s3.bucket_regional_domain_name
        origin_access_control_id = aws_cloudfront_origin_access_control.edge_oac.id
        origin_id = "s3_origin"
    }
    default_cache_behavior {
        target_origin_id = "s3_origin"
        viewer_protocol_policy = "redirect-to-https"
        allowed_methods = ["GET","HEAD"]
        cached_methods = ["GET","HEAD"]
        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
    }
    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }
    viewer_certificate {
        cloudfront_default_certificate = true
    }
}
