terraform {
    backend "s3" {
        bucket = "terraform-statefile-host-s3-bucket"
        key = "static_host/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
        use_lockfile = true
    }
}
