generate_hcl "_terramate_generated_variables.tf" {
  content {

    variable "product_name" {
      type    = string
      default = "demonix"
    }

    variable "environment" {
      type    = string
      default = "development"
    }

    variable "region" {
      type    = string
      default = "australiaeast"
    }


    variable "azs" {
      type    = string
      default = ""
    }

    variable "service_name" {
      type    = string
      default = ""
    }

    variable "vm_size" {
      type    = string
      default = ""
    }
    variable "vm_offer" {
      type    = string
      default = ""
    }
    variable "vm_sku" {
      type    = string
      default = ""
    }
    variable "sql_admin_name" {
      type    = string
      default = "sqladmin"
    }

    variable "sql_admin_password" {
      type    = string
      default = "NOTsoSecurePassword893!"
    }

    variable "database_name" {
      type    = string
      default = "wordpressdb"
    }

    locals {
      resource_group_name            = join("-", ["rg", var.product_name, var.environment])
      network_security_group_name    = join("-", ["nsg", var.product_name, var.environment])
      network_interface_name         = join("-", ["nic", var.product_name, var.environment])
      virtual_machine_name           = join("-", ["vm", var.product_name, var.environment])
      http_setting_name              = join("-", ["behtst", var.product_name, var.environment])
      listener_name                  = join("-", ["httplstn", var.product_name, var.environment])
      request_routing_rule_name      = join("-", ["rqrt", var.product_name, var.environment])
      frontend_port_name             = join("-", ["feport", var.product_name, var.environment])
      frontend_ip_configuration_name = join("-", ["feip", var.product_name, var.environment])
      backend_address_pool_name      = join("-", ["beap", var.product_name, var.environment])
      public_ip_address_name         = join("-", ["pip", var.product_name, var.environment])
      rg_name                        = join("-", ["rg", var.product_name, var.environment])
      waf_policy_name                = join("-", ["waf", var.product_name, var.environment])
      app_gateway_name               = join("-", ["agw", var.product_name, var.environment])
      vnet_name                       = join("-", ["vnet", var.product_name, var.environment])
      planName                       = join("-", ["plan", var.product_name, var.environment])
      appName                        = join("-", ["app", var.product_name, var.service_name, var.environment])

      sql_server_name = join("-", ["mysql", var.product_name, var.environment])
      # sqlPoolName     = join("-", ["pool", var.product_name, var.environment])
      # sqlDBName       = join("-", ["sqldb", var.databaseName , var.environment])
      # sqlDBName1      = join("-", ["sqldb", var.databaseName1 , var.environment])
    }
  }
}
