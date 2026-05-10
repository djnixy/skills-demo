resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.region
}

resource "azurerm_resource_group" "rgshared" {
  name     = local.rg_shared_name
  location = var.region
}

resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = azurerm_resource_group.rgshared.name
  location            = azurerm_resource_group.rgshared.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_service_plan" "appserviceplan" {
  name                = local.plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = local.rg_name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = local.app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true

  app_settings = {
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = azurerm_container_registry.acr.admin_password
    "DOCKER_REGISTRY_SERVER_URL"          = azurerm_container_registry.acr.login_server
    "DOCKER_REGISTRY_SERVER_USERNAME"     = azurerm_container_registry.acr.admin_username
    "WEBSITE_HTTPLOGGING_RETENTION_DAYS"  = 7
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = false
  }

  site_config {
    minimum_tls_version = "1.2"
    always_on           = true

    application_stack {
      docker_image     = "nginx"
      docker_image_tag = "latest"
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

resource "azurerm_mssql_server" "mssqlserver" {
  name                         = local.sql_server_name
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  version                      = "12.0"
  minimum_tls_version          = "1.2"
  administrator_login          = var.sql_admin_name
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_firewall_rule" "mssqlfirewallrule" {
  name             = "FirewallRule1"
  server_id        = azurerm_mssql_server.mssqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_elasticpool" "mssqlelasticpool" {
  name                = local.sql_pool_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mssql_server.mssqlserver.name
  #   license_type        = "LicenseIncluded"
  max_size_gb = 4.8828125

  sku {
    name = "BasicPool"
    tier = "Basic"
    # family   = "Gen4"
    capacity = 50
  }

  per_database_settings {
    min_capacity = 0
    max_capacity = 5
  }
}

resource "azurerm_mssql_database" "mssqldatabase" {
  name                 = local.sql_db_name
  server_id            = azurerm_mssql_server.mssqlserver.id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  license_type         = "LicenseIncluded"
  elastic_pool_id      = azurerm_mssql_elasticpool.mssqlelasticpool.id
  sku_name             = "ElasticPool"
  zone_redundant       = false
  storage_account_type = "Local"
}