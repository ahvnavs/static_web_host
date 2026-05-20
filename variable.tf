variable "default_region" {
    description = "default aws region"
    type = string
    default = "ap-south-1"
}

variable "tags" {
    description = "project tags"
    type = object({
        name = string
        env = string
        cloud = string
        provision = string
    })
    default = {
        name = "static_host"
        env = "local_host"
        cloud = "aws"
        provision = "terraform"
    }
}

variable "az" {
    description = "az"
    type = list(string)
    default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}
