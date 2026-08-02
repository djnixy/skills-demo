generate_hcl "_terramate_generated_variables.tf" {
  content {

    variable "project_name" {
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
      resource_group_name            = join("-", ["rg", var.project_name, var.environment])
      network_security_group_name    = join("-", ["nsg", var.project_name, var.environment])
      network_interface_name         = join("-", ["nic", var.project_name, var.environment])
      virtual_machine_name           = join("-", ["vm", var.project_name, var.environment])
      http_setting_name              = join("-", ["behtst", var.project_name, var.environment])
      listener_name                  = join("-", ["httplstn", var.project_name, var.environment])
      request_routing_rule_name      = join("-", ["rqrt", var.project_name, var.environment])
      frontend_port_name             = join("-", ["feport", var.project_name, var.environment])
      frontend_ip_configuration_name = join("-", ["feip", var.project_name, var.environment])
      backend_address_pool_name      = join("-", ["beap", var.project_name, var.environment])
      public_ip_address_name         = join("-", ["pip", var.project_name, var.environment])
      rg_name                        = join("-", ["rg", var.project_name, var.environment])
      waf_policy_name                = join("-", ["waf", var.project_name, var.environment])
      app_gateway_name               = join("-", ["agw", var.project_name, var.environment])
      vnet_name                       = join("-", ["vnet", var.project_name, var.environment])
      planName                       = join("-", ["plan", var.project_name, var.environment])
      appName                        = join("-", ["app", var.project_name, var.service_name, var.environment])

      sql_server_name = join("-", ["mysql", var.project_name, var.environment])
      # sqlPoolName     = join("-", ["pool", var.project_name, var.environment])
      # sqlDBName       = join("-", ["sqldb", var.databaseName , var.environment])
      # sqlDBName1      = join("-", ["sqldb", var.databaseName1 , var.environment])
    }
  }
}
