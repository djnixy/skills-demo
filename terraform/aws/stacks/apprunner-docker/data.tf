data "http" "myip" {
  url = "https://ifconfig.me/ip"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

## VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "zone-a" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "availability-zone"
    values = ["${var.deploy_region}a"]
  }
}

data "aws_subnet" "zone-b" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "availability-zone"
    values = ["${var.deploy_region}b"]
  }
}

