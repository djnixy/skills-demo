# variable "subscription_id" {}

# variable "productName" {
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

#     rgName          = join("-", ["rg", var.productName, var.env])
#     rgSharedName    = join("-", ["rg", var.productName, "shared"])
#     vnetName        = join("-", ["vnet", var.productName, var.env])
#     planName        = join("-", ["plan", var.productName, var.env])
#     appName         = join("-", ["app", var.productName, var.serviceName, var.env])
#     appName1        = join("-", ["app", var.productName, var.serviceName1, var.env])
#     acrName         = var.productName

#     sqlServerName   = join("-", ["sql", var.productName, var.env]) 
#     sqlPoolName     = join("-", ["pool", var.productName, var.env])
#     sqlDBName       = join("-", ["sqldb", var.databaseName , var.env])
#     sqlDBName1      = join("-", ["sqldb", var.databaseName1 , var.env])
# }

