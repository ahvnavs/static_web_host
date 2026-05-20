provider "aws" {
    region = var.default_region
}

resource "aws_s3_bucket" "bucket_s3" {
    bucket = ""
    depends_on = []
    lifecycle {
        prevent_destroy = true
    }
    object_lock_enabled = true
    provider = aws
    region = var.default_region
    tags = var.tags
}

resource "aws_s3_bucket_versioning" "version_s3" {
    bucket = aws_s3_bucket.bucket_s3.id
    depends_on = []
    lifecycle {
        prevent_destroy = true
    }
    provider = aws
    region = var.default_region
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_s3" {
    bucket = aws_s3_bucket.bucket_s3.id
    rule {
    }
    depends_on = []
    lifecycle {
        prevent_destroy = true
    }
    provider = aws
    region = var.default_region
}


resource "aws_vpc" "vc_vpc" {
    cidr_block = ""
    depends_on = []
    enable_dns_hostnames = true
    enable_dns_support = true
    enable_network_address_usage_metrics = true
    lifecycle {
        create_before_destroy = true
    }
    provider = aws
    region = var.default_region
    tags = var.tags
}

resource "aws_subnet" "sub_vpc" {
    vpc_id = aws_vpc.vc_vpc.id
    availability_zone = var.az[0]
    cidr_block = ""
    depends_on = []
    lifecycle {
        create_before_destroy = true
    }
    provider = aws
    region = var.default_region
    tags = var.tags
}
