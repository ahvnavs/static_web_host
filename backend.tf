terraform {
    backend "s3" {
        bucket = "statefile-host-bucket"
        key = "static_host/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
        use_lockfile = true
    }
}
