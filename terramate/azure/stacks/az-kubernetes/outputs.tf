# Resource Group Outputs
output "resource_group_name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "The ID of the resource group."
  value       = azurerm_resource_group.this.id
}

output "resource_group_location" {
  description = "The location of the resource group."
  value       = azurerm_resource_group.this.location
}

# Network Outputs
output "vnet_id" {
  description = "The ID of the virtual network."
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The name of the virtual network."
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_address_space" {
  description = "The address space of the virtual network."
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnet_hosts_a_id" {
  description = "The ID of subnet hosts-a."
  value       = azurerm_subnet.a.id
}

output "subnet_hosts_b_id" {
  description = "The ID of subnet hosts-b."
  value       = azurerm_subnet.b.id
}

output "subnet_database_id" {
  description = "The ID of the database subnet."
  value       = azurerm_subnet.databasesubnet.id
}

# AKS Cluster Outputs
output "cluster_name" {
  description = "The name of the AKS managed cluster."
  value       = module.aks.name
}

output "cluster_id" {
  description = "The resource ID of the AKS managed cluster."
  value       = module.aks.resource_id
}

output "cluster_fqdn" {
  description = "The FQDN of the AKS cluster control plane."
  value       = module.aks.fqdn
}

output "cluster_kubernetes_version" {
  description = "The Kubernetes version running on the cluster."
  value       = module.aks.current_kubernetes_version
}

output "cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL for Workload Identity."
  value       = module.aks.oidc_issuer_profile_issuer_url
}

output "cluster_node_resource_group" {
  description = "The auto-created node resource group containing VMSS resources."
  value       = module.aks.node_resource_group_name
}

output "cluster_identity_principal_id" {
  description = "The principal ID of the cluster managed identity."
  value       = module.aks.identity_principal_id
}

output "cluster_kubelet_identity" {
  description = "The user-assigned identity used by the kubelet on worker nodes."
  value       = module.aks.kubelet_identity
}

# Azure AD / RBAC Outputs
output "admin_group_object_id" {
  description = "The object ID of the Entra ID 'Admin All' group assigned cluster-admin role."
  value       = data.azuread_group.admin_all.object_id
}

output "admin_group_display_name" {
  description = "The display name of the Entra ID admin group."
  value       = data.azuread_group.admin_all.display_name
}
