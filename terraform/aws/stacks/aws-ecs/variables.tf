data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

variable "product_name" {
  # description = "CIDR block for VPC"
  type        = string
  default = ""
}

variable "environment" {
  # description = "CIDR block for VPC"
  type        = string
  default = ""
}

variable "aws_access_key_id" {
  # description = "CIDR block for VPC"
  type        = string
  default = ""
}

variable "aws_secret_access_key" {
  # description = "CIDR block for VPC"
  type        = string
  default = ""
}

variable "alb_sg_name" {
  # description = "CIDR block for VPC"
  type        = string
  default = ""
}

variable "ecs_sg_frontend_name" {
  # description = "CIDR block for VPC"
  type        = string
  default = ""
}

variable "ecs_sg_backend_name" {
  # description = "CIDR block for VPC"
  type        = string
  default = ""
}

variable "vpc_id" {
  # description = "CIDR block for VPC"
  type        = string
  default = ""
}

variable "alb_name" {
  # description = "CIDR block for VPC"
  type        = string
  default = ""
}

variable "domain_name" {
  # description = "CIDR block for VPC"
  type        = string
  default = ""
}

variable "app_count" {
  type = number
  default = 1
}

variable "ecsTaskExecutionRole" {
  type = string
  default = "arn:aws:iam::467726254276:role/ecsTaskExecutionRole"
}

locals {
  # Common tags to be assigned to all resources
  # common_tags = {
  #   Service = local.service_name
  #   Owner   = local.owner
  # }

  alb_sg_name = join("-", ["alb", var.product_name, var.environment , "sg"])
  alb_name = join("-", ["alb", var.product_name, var.environment])

  ecs_sg_frontend_name = join("-", ["ecs", var.product_name, "fe", var.environment , "sg"])
  ecs_sg_backend_name = join("-", ["ecs", var.product_name, "be", var.environment , "sg"])

  rds_sg_name = join("-", ["rds", var.product_name, var.environment , "sg"])

  tg_frontend_name =join("-", ["tg", var.product_name, "fe", var.environment])
  tg_backend_name = join("-", ["tg", var.product_name, "be", var.environment])

  cluster_name = join("-", [var.product_name, var.environment])
  service_frontend_name= join("-", ["service", var.product_name, "fe", var.environment])
  service_backend_name= join("-", ["service", var.product_name, "be", var.environment])

  td_frontend= join("-", [var.product_name, "fe", var.environment])
  td_backend= join("-", [var.product_name, "be", var.environment])
}