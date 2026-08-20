
resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.99.0.0/16"]
  location            = azurerm_resource_group.this.location
  name                = local.vnet_name
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
