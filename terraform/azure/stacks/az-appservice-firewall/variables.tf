variable "projectName" {
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
#     http_setting_name =  join("-", ["behtst", var.projectName, var.environment])
#     listener_name = join("-", ["httplstn", var.projectName, var.environment])
#     request_routing_rule_name = join("-", ["rqrt", var.projectName, var.environment])
#     frontend_port_name = join("-", ["feport", var.projectName, var.environment])
#     frontend_ip_configuration_name = join("-", ["feip", var.projectName, var.environment])
#     backend_address_pool_name = join("-", ["beap", var.projectName, var.environment])
#     public_ip_address_name = join("-", ["pip", var.projectName, var.environment])
#     rgName          = join("-", ["rg", var.projectName, var.environment])
#     waf_policy_name = join("-", ["waf", var.projectName, var.environment])
#     appGatewayName  = join("-", ["agw", var.projectName, var.environment])
#     vnetName        = join("-", ["vnet", var.projectName, var.environment])
#     planName        = join("-", ["plan", var.projectName, var.environment])
#     appName         = join("-", ["app", var.projectName, var.serviceName, var.environment])

#     sqlServerName   = join("-", ["mysql", var.projectName, var.environment]) 
#     # sqlPoolName     = join("-", ["pool", var.projectName, var.environment])
#     # sqlDBName       = join("-", ["sqldb", var.databaseName , var.environment])
#     # sqlDBName1      = join("-", ["sqldb", var.databaseName1 , var.environment])
# }

