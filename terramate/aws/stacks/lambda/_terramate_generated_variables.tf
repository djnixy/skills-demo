// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

variable "project_name" {
  default = "demonix"
  type    = string
}
variable "environment" {
  default = "development"
  type    = string
}
variable "deploy_region" {
  default = "ap-southeast-1"
  type    = string
}
variable "service_name" {
  default = "portal"
  type    = string
}
variable "vpc_cidr" {
  default = ""
  type    = string
}
variable "azs" {
  default = ""
  type    = string
}
variable "database_admin_name" {
  default = "sqladmin"
  type    = string
}
variable "database_admin_password" {
  default = ""
  type    = string
}
variable "database_name" {
  default = "api"
  type    = string
}
locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
  ecsTaskExecutionRole = join("", [
    "arn:aws:iam::",
    data.aws_caller_identity.current.account_id,
    ":role/ecsTaskExecutionRole",
  ])
  monitoring_role_arn = join("", [
    "arn:aws:iam::",
    data.aws_caller_identity.current.account_id,
    ":role/rds-monitoring-role",
  ])
}
