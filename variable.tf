variable "default_region" {
    description = "default aws region"
    type = string
    default = "us-east-1"
}

variable "tags" {
    description = "project tags"
    type = map(string)
    default = {
        "name" = "static_host"
        "env" = "local_host"
        "cloud" = "aws"
        "provision" = "terraform"
    }
}
