resource "azurerm_mysql_flexible_server" "this" {

  name                   = local.sqlServerName
  resource_group_name    = azurerm_resource_group.this.name
  location               = azurerm_resource_group.this.location
  administrator_login    = var.sqlAdminName
  administrator_password = var.sqlAdminPassword
  backup_retention_days  = 1
  delegated_subnet_id    = azurerm_subnet.database.id
  # private_dns_zone_id    = azurerm_private_dns_zone.this.id
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"
  zone                   = "1"
}
