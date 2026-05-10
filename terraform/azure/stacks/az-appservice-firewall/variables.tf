variable "productName" {
  # description = ""
  type        = string
  default = ""
}

variable "serviceName" {
  # description = ""
  type        = string
  default = ""
}

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

# locals {
#   # Common tags to be assigned to all resources
#   # common_tags = {
#   #   Service = local.service_name
#   #   Owner   = local.owner
#   # }
#     http_setting_name =  join("-", ["behtst", var.productName, var.environment])
#     listener_name = join("-", ["httplstn", var.productName, var.environment])
#     request_routing_rule_name = join("-", ["rqrt", var.productName, var.environment])
#     frontend_port_name = join("-", ["feport", var.productName, var.environment])
#     frontend_ip_configuration_name = join("-", ["feip", var.productName, var.environment])
#     backend_address_pool_name = join("-", ["beap", var.productName, var.environment])
#     public_ip_address_name = join("-", ["pip", var.productName, var.environment])
#     rgName          = join("-", ["rg", var.productName, var.environment])
#     waf_policy_name = join("-", ["waf", var.productName, var.environment])
#     appGatewayName  = join("-", ["agw", var.productName, var.environment])
#     vnetName        = join("-", ["vnet", var.productName, var.environment])
#     planName        = join("-", ["plan", var.productName, var.environment])
#     appName         = join("-", ["app", var.productName, var.serviceName, var.environment])

#     sqlServerName   = join("-", ["mysql", var.productName, var.environment]) 
#     # sqlPoolName     = join("-", ["pool", var.productName, var.environment])
#     # sqlDBName       = join("-", ["sqldb", var.databaseName , var.environment])
#     # sqlDBName1      = join("-", ["sqldb", var.databaseName1 , var.environment])
# }

