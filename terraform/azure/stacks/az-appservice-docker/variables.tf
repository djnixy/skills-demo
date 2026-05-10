variable "project_name" {
  # description = ""
  type    = string
  default = ""
}

variable "service_name" {
  # description = ""
  type    = string
  default = ""
}

variable "service_name1" {
  # description = ""
  type    = string
  default = ""
}

variable "env" {
  # description = ""
  type    = string
  default = "development"
}

variable "region" {
  # description = ""
  type    = string
  default = ""
}

variable "sql_admin_name" {
  # description = ""
  type    = string
  default = "sqladmin"
}

variable "sql_admin_password" {
  # description = ""
  type    = string
  default = "NOTsoSecurePassword893!"
}

variable "database_name" {
  # description = ""
  type    = string
  default = "api"
}

variable "database_name1" {
  # description = ""
  type    = string
  default = ""
}

locals {
  # Common tags to be assigned to all resources
  # common_tags = {
  #   Service = local.service_name
  #   Owner   = local.owner
  # }

  rg_name         = join("-", ["rg", var.project_name, var.env])
  rg_shared_name  = join("-", ["rg", var.project_name, "shared"])
  plan_name       = join("-", ["plan", var.project_name, var.env])
  app_name        = join("-", ["app", var.project_name, var.service_name, var.env])
  app_name1       = join("-", ["app", var.project_name, var.service_name1, var.env])
  acr_name        = var.project_name

  sql_server_name = join("-", ["sql", var.project_name, var.env])
  sql_pool_name   = join("-", ["pool", var.project_name, var.env])
  sql_db_name     = join("-", ["sqldb", var.database_name, var.env])
  sql_db_name1    = join("-", ["sqldb", var.database_name1, var.env])
}
