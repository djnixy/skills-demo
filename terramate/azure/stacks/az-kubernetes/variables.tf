# variable "subscription_id" {}

# variable "projectName" {
#   # description = ""
#   type        = string
#   default = ""
# }

# variable "serviceName" {
#   # description = ""
#   type        = string
#   default = ""
# }

# variable "serviceName1" {
#   # description = ""
#   type        = string
#   default = ""
# }

# variable "env" {
#   # description = ""
#   type        = string
#   default = "development"
# }

# variable "region" {
#   # description = ""
#   type        = string
#   default = ""
# }

# variable "sqlAdminName" {
#   # description = ""
#   type        = string
#   default = "sqladmin"
# }

# variable "sqlAdminPassword" {
#   # description = ""
#   type        = string
#   default = "NOTsoSecurePassword893!"
# }

# variable "databaseName" {
#   # description = ""
#   type        = string
#   default = "api"
# }

# variable "databaseName1" {
#   # description = ""
#   type        = string
#   default = ""
# }

# locals {
#   # Common tags to be assigned to all resources
#   # common_tags = {
#   #   Service = local.service_name
#   #   Owner   = local.owner
#   # }

#     rgName          = join("-", ["rg", var.projectName, var.env])
#     rgSharedName    = join("-", ["rg", var.projectName, "shared"])
#     vnetName        = join("-", ["vnet", var.projectName, var.env])
#     planName        = join("-", ["plan", var.projectName, var.env])
#     appName         = join("-", ["app", var.projectName, var.serviceName, var.env])
#     appName1        = join("-", ["app", var.projectName, var.serviceName1, var.env])
#     acrName         = var.projectName

#     sqlServerName   = join("-", ["sql", var.projectName, var.env]) 
#     sqlPoolName     = join("-", ["pool", var.projectName, var.env])
#     sqlDBName       = join("-", ["sqldb", var.databaseName , var.env])
#     sqlDBName1      = join("-", ["sqldb", var.databaseName1 , var.env])
# }

