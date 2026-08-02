# resource "azurerm_mysql_flexible_server" "this" {
#   name                   = local.sql_server_name
#   resource_group_name    = azurerm_resource_group.this.name
#   location               = azurerm_resource_group.this.location
#   administrator_login    = var.sql_admin_name
#   administrator_password = var.sql_admin_password
#   backup_retention_days  = 1
#   delegated_subnet_id    = azurerm_subnet.database.id
#   sku_name               = "B_Standard_B1ms"
#   version                = "8.0.21"
#   zone                   = "1"
# }

# resource "azurerm_mysql_flexible_server_firewall_rule" "azure" {
#   name                = "AzureServices"
#   resource_group_name = azurerm_resource_group.this.name
#   server_name         = azurerm_mysql_flexible_server.this.name
#   start_ip_address    = "0.0.0.0"
#   end_ip_address      = "0.0.0.0"
# }

# resource "azurerm_mysql_flexible_server_firewall_rule" "this" {
#   name                = "niki"
#   resource_group_name = azurerm_resource_group.example.name
#   server_name         = azurerm_mysql_flexible_server.example.name
#   start_ip_address    = data.http.myip.request_body
#   end_ip_address      = data.http.myip.request_body
# }


# resource "azurerm_mysql_flexible_database" "this" {
#   name                = local.database_name
#   resource_group_name = azurerm_resource_group.this.name
#   server_name         = azurerm_mysql_flexible_server.this.name
#   charset             = "utf8"
#   collation           = "utf8_unicode_ci"
# }