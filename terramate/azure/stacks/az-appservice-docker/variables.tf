variable "project_name" {
  description = "Project name"
  type        = string
  default     = "demoazure"
}

variable "service_name" {
  description = "Service name"
  type        = string
  default     = ""
}

variable "service_name1" {
  description = "Service name"
  type        = string
  default     = ""
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "development"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "eastus"
}

variable "sql_admin_name" {
  description = "SQL server admin name"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "SQL server admin password"
  type        = string
  default     = "NOTsoSecurePassword893!"
}

variable "database_name" {
  description = "SQL server database name"
  type        = string
  default     = "api"
}

variable "database_name1" {
  description = "SQL server database name"
  type        = string
  default     = ""
}

locals {
  # Common tags to be assigned to all resources
  # common_tags = {
  #   Service = local.service_name
  #   Owner   = local.owner
  # }

  rg_name        = join("-", ["rg", var.project_name, var.env])
  rg_shared_name = join("-", ["rg", var.project_name, "shared"])
  plan_name      = join("-", ["plan", var.project_name, var.env])
  app_name       = join("-", ["app", var.project_name, var.service_name, var.env])
  app_name1      = join("-", ["app", var.project_name, var.service_name1, var.env])
  acr_name       = var.project_name

  sql_server_name = join("-", ["sql", var.project_name, var.env])
  sql_pool_name   = join("-", ["pool", var.project_name, var.env])
  sql_db_name     = join("-", ["sqldb", var.database_name, var.env])
  sql_db_name1    = join("-", ["sqldb", var.database_name1, var.env])
}
