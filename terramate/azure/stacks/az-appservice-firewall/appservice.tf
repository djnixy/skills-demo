resource "azurerm_service_plan" "appserviceplan" {
  name                = local.planName
  location            = azurerm_resource_group.this.location
  resource_group_name = local.rgName
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "webapp" {
  name                      = local.appName
  location                  = azurerm_resource_group.this.location
  resource_group_name       = azurerm_resource_group.this.name
  service_plan_id           = azurerm_service_plan.appserviceplan.id
  # public_network_access_enabled = false
  https_only                = true
  virtual_network_subnet_id = azurerm_subnet.a.id

  app_settings = {
      "DB_SERVER"       = azurerm_mysql_flexible_server.this.fqdn
  }

  site_config { 
    minimum_tls_version     = "1.2"
    always_on               = true
    health_check_path       = "/"
    
    application_stack {
      docker_image_name = "vulnerables/web-dvwa:latest"
    }
    
  }
  
  logs {
      http_logs {
          file_system {
              retention_in_mb   = 35
              retention_in_days = 7           
          }
      }
  }
}