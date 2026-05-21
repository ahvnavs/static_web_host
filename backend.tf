terraform {
    backend "s3" {
        bucket = "static-host-terraform-state"
        key = "static_host/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
        use_lockfile = true
    }
}
