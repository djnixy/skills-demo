resource "random_id" "prefix" {
  byte_length = 8
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.region
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.99.0.0/16"]
  location            = azurerm_resource_group.this.location
  name                = local.vnetName
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "a" {
  address_prefixes     = ["10.99.0.0/20"]
  name                 = "snet-hosts-a"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "b" {
  address_prefixes     = ["10.99.16.0/20"]
  name                 = "snet-hosts-b"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "databasesubnet" {
  address_prefixes     = ["10.99.240.0/20"]
  name                 = "snet-database"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

locals {
  nodes = {
    for i in range(1) : "worker${i}" => {
      name                  = substr("worker${i}${random_id.prefix.hex}", 0, 8)
      vm_size               = "Standard_D2s_v3"
      node_count            = 1
      vnet_subnet_id        = azurerm_subnet.a.id
      create_before_destroy = i % 2 == 0
    }
  }
}

module "aks" {
  source  = "Azure/aks/azurerm"
  version = "9.1.0"

  depends_on = [
    azurerm_resource_group.this
  ]

  prefix              = "prefix-${random_id.prefix.hex}"
  cluster_name        = join("-", ["aks", var.project_name, var.environment])
  resource_group_name = azurerm_resource_group.this.name
  # location = "eastus2"
  os_disk_size_gb                   = 50
  sku_tier                          = "Standard"
  rbac_aad                          = false
  log_analytics_workspace_enabled   = false
  role_based_access_control_enabled = false

  # create_role_assignments_for_application_gateway = true
  vnet_subnet_id = azurerm_subnet.a.id
  node_pools     = local.nodes
  enable_auto_scaling = false
  enable_host_encryption = false


}
