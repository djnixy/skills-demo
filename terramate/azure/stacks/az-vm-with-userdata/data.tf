data "azurerm_public_ip" "this" {
  name                = azurerm_public_ip.this.name
  resource_group_name = azurerm_resource_group.this.name
}