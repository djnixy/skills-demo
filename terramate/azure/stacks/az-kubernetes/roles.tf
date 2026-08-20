
resource "azurerm_role_assignment" "admin_all_aks_cluster_admin" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azuread_group.admin_all.object_id
}

resource "azurerm_role_assignment" "admin_all_aks_cluster_user" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = data.azuread_group.admin_all.object_id
}

resource "azurerm_role_assignment" "current_user_aks_cluster_admin" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "current_user_aks_cluster_user" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = data.azurerm_client_config.current.object_id
}