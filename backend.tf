terraform {
    backend "s3" {
        bucket = ""
        backend = ""
        encrypt = true
        key = ""
        region = "ap-south-1"
        use_lockfile = true
    }
}
