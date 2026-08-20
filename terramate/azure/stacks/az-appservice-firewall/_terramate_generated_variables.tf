// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

variable "project_name" {
  default = "demonix"
  type    = string
}
variable "environment" {
  default = "development"
  type    = string
}
variable "region" {
  default = "australiaeast"
  type    = string
}
variable "azs" {
  default = ""
  type    = string
}
variable "service_name" {
  default = ""
  type    = string
}
variable "vm_size" {
  default = ""
  type    = string
}
variable "vm_offer" {
  default = ""
  type    = string
}
variable "vm_sku" {
  default = ""
  type    = string
}
variable "sql_admin_name" {
  default = "sqladmin"
  type    = string
}
variable "sql_admin_password" {
  default = ""
  type    = string
}
variable "database_name" {
  default = "wordpressdb"
  type    = string
}
locals {
  appName = join("-", [
    "app",
    var.project_name,
    var.service_name,
    var.environment,
  ])
  app_gateway_name = join("-", [
    "agw",
    var.project_name,
    var.environment,
  ])
  backend_address_pool_name = join("-", [
    "beap",
    var.project_name,
    var.environment,
  ])
  frontend_ip_configuration_name = join("-", [
    "feip",
    var.project_name,
    var.environment,
  ])
  frontend_port_name = join("-", [
    "feport",
    var.project_name,
    var.environment,
  ])
  http_setting_name = join("-", [
    "behtst",
    var.project_name,
    var.environment,
  ])
  listener_name = join("-", [
    "httplstn",
    var.project_name,
    var.environment,
  ])
  network_interface_name = join("-", [
    "nic",
    var.project_name,
    var.environment,
  ])
  network_security_group_name = join("-", [
    "nsg",
    var.project_name,
    var.environment,
  ])
  planName = join("-", [
    "plan",
    var.project_name,
    var.environment,
  ])
  public_ip_address_name = join("-", [
    "pip",
    var.project_name,
    var.environment,
  ])
  request_routing_rule_name = join("-", [
    "rqrt",
    var.project_name,
    var.environment,
  ])
  resource_group_name = join("-", [
    "rg",
    var.project_name,
    var.environment,
  ])
  rg_name = join("-", [
    "rg",
    var.project_name,
    var.environment,
  ])
  sql_server_name = join("-", [
    "mysql",
    var.project_name,
    var.environment,
  ])
  virtual_machine_name = join("-", [
    "vm",
    var.project_name,
    var.environment,
  ])
  vnet_name = join("-", [
    "vnet",
    var.project_name,
    var.environment,
  ])
  waf_policy_name = join("-", [
    "waf",
    var.project_name,
    var.environment,
  ])
}
