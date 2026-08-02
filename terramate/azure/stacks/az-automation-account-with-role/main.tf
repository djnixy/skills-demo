data "local_file" "sqlexport" {
  filename = "../../sql-export-to-blob.ps1"
}

resource "azurerm_automation_account" "azure-aa" {
  name                = var.automation_account_name
  location            = var.region
  resource_group_name = var.resource_group_name

  sku_name = "Basic"
  identity  {
    type = "SystemAssigned"
  }
}

resource "azurerm_automation_schedule" "this" {
  name                    = "sql-export-schedule"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  frequency               = "Day"
  interval                = 1
  timezone                = "Etc/UTC"
  start_time              = "${formatdate("YYYY-MM-DD", timestamp())}T17:00:00+00:00"
  

  description             = "Run everyday at 3 AM AEST"
}

resource "azurerm_automation_variable_string" "BlobContainerName" {
  name                    = "BlobContainerName"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  value                   = var.azure_blob_container_name
}

resource "azurerm_automation_variable_string" "BlobStorageEndpoint" {
  name                    = "BlobStorageEndpoint"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  value                   = var.azure_blob_storage_endpoint
}

resource "azurerm_automation_variable_string" "DatabaseAdminPassword" {
  name                    = "DatabaseAdminPassword"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  value                   = var.azure_database_admin_password
  encrypted               = true
}

resource "azurerm_automation_variable_string" "DatabaseAdminUsername" {
  name                    = "DatabaseAdminUsername"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  value                   = var.azure_database_admin_username
}
resource "azurerm_automation_variable_string" "DatabaseNames" {
  name                    = "DatabaseNames"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  value                   = var.azure_database_names
}

resource "azurerm_automation_variable_string" "DatabaseServerName" {
  name                    = "DatabaseServerName"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  value                   = var.azure_database_server_name
}

resource "azurerm_automation_variable_string" "ErrorActionPreference" {
  name                    = "ErrorActionPreference"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  value                   = "Stop"
}

resource "azurerm_automation_variable_string" "ResourceGroupName" {
  name                    = "ResourceGroupName"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  value                   = var.resource_group_name
}

resource "azurerm_automation_variable_string" "RetentionDays" {
  name                    = "RetentionDays"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  value                   = var.backup_retention_days
}

resource "azurerm_automation_variable_string" "StorageAccountName" {
  name                    = "StorageAccountName"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  value                   = var.storage_account_name
}

resource "azurerm_automation_variable_string" "StorageKey" {
  name                    = "StorageKey"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  value                   = var.azure_storage_key
  encrypted               = true
}


resource "azurerm_automation_runbook" "sqlexport" {
  name                    = "sql-to-blob"
  location                = var.region
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "Runbook for exporting database backup to selected blob in an Azure Storage container"
  runbook_type            = "PowerShell"

  content = data.local_file.sqlexport.content
}

resource "azurerm_automation_job_schedule" "sqlexport" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.azure-aa.name
  schedule_name           = azurerm_automation_schedule.this.name
  runbook_name            = azurerm_automation_runbook.sqlexport.name
}

resource "azurerm_storage_container" "backup-container" {
  name                  = "cg-${local.environment}-backup"
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "storage" {
  scope                = "data.azurerm_storage_account.this.id"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_automation_account.this.identity[0].principal_id
}