generate_hcl "_terramate_generated_variables.tf" {
  content {

variable "product_name" {
  # description = ""
  type        = string
  default = "demonix"
}

variable "environment" {
  # description = ""
  type        = string
  default = "development"
}

variable "deploy_region" {
  # description = ""
  type        = string
  default = "ap-southeast-1"
}

variable "service_name" {
  # description = ""
  type        = string
  default = "portal"
}

variable "vpc_cidr" {
  type        = string
  default = ""
}

variable "azs" {
  type        = string
  default = ""
}

variable "database_admin_name" {
  # description = ""
  type        = string
  default = "sqladmin"
}

variable "database_admin_password" {
  # description = ""
  type        = string
  default = "NOTsoSecurePassword893!"
}

variable "database_name" {
  # description = ""
  type        = string
  default = "api"
}

locals {

  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
  ecsTaskExecutionRole  = join("", ["arn:aws:iam::", data.aws_caller_identity.current.account_id, ":role/ecsTaskExecutionRole"])
  monitoring_role_arn   = join("", ["arn:aws:iam::", data.aws_caller_identity.current.account_id, ":role/rds-monitoring-role"])
}




  }
}
