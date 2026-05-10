data "azurerm_subscription" "current" {}

data "local_file" "script" {
  filename = "../../script-with-managed-identity.py"
}

data "azurerm_storage_account" "this" {
  name                = var.existing_storage_account_name
  resource_group_name = "rg-shared"
}

data "azurerm_key_vault" "this" {
  name                = "kv-operation-production"
  resource_group_name = "rg-shared"
}

data "azurerm_key_vault_secret" "this" {
  name         = "erp-flexidev-co-odoo-admin-password"
  key_vault_id = data.azurerm_key_vault.this.id
}