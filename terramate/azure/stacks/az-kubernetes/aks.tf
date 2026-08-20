
module "aks" {
  source  = "Azure/avm-res-containerservice-managedcluster/azurerm"
  version = "0.8.1"

  name      = join("-", ["aks", var.project_name, var.environment])
  location  = azurerm_resource_group.this.location
  parent_id = azurerm_resource_group.this.id

  sku = {
    name = "Base"
    tier = "Standard"
  }
  enable_telemetry       = false
  disable_local_accounts = true

  # Default System Node Pool - Multi-AZ deployed across 3 Availability Zones (1, 2, 3) for High Availability
  default_agent_pool = {
    name                      = "systempool"
    vm_size                   = "Standard_D2s_v3"
    availability_zones        = ["1", "2"] # ["1", "2", "3"] 3 AZ is recommended, 2 for testing/concepting
    count_of                  = 2               # Set to 3 if 3 AZ is set
    enable_auto_scaling       = true
    min_count                 = 2               # Set to 3 if 3 AZ is set
    max_count                 = 2
    enable_encryption_at_host = false
    os_disk_size_gb           = 50
    vnet_subnet_id            = azurerm_subnet.a.id
  }

  agent_pools = {
    # Secondary Spot Node Pool - Multi-AZ enabled to maximize spot capacity across all 3 zones
    spot = {
      name                      = "spotpool"
      mode                      = "User"
      vm_size                   = "Standard_D2s_v3"
      availability_zones        = ["1", "2", "3"] # Spreads Spot VMs across all 3 zones to maximize spot capacity availability
      os_disk_size_gb           = 50
      vnet_subnet_id            = azurerm_subnet.a.id
      scale_set_priority        = "Spot"
      scale_set_eviction_policy = "Delete"
      spot_max_price            = -1 # -1 means up to On-Demand pricing cap
      enable_auto_scaling       = true
      min_count                 = 0  # Scales to 0 when idle to save cost
      max_count                 = 6
      node_labels = {
        "kubernetes.azure.com/scalesetpriority" = "spot"
        "workload"                              = "spot"
      }
      node_taints = [
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
    }
  }

  auto_scaler_profile = {
    balance_similar_node_groups      = true
    expander                         = "random" # "least-waste", "priority", "most-pods"
    scale_down_delay_after_add       = "10m"
    scale_down_unneeded_time         = "10m"
    scale_down_utilization_threshold = 0.5
    scan_interval                    = "10s"
  }

  aad_profile = {
    managed                = true
    enable_azure_rbac      = true
    admin_group_object_ids = [data.azuread_group.admin_all.object_id]
  }

  oidc_issuer_profile = {
    enabled = true
  }

  security_profile = {
    workload_identity = {
      enabled = true
    }
    image_cleaner = {
      enabled        = true
      interval_hours = 48
    }
  }
}

resource "terraform_data" "kubeconfig" {
  depends_on = [module.aks]

  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${azurerm_resource_group.this.name} --name ${join("-", ["aks", var.project_name, var.environment])} --overwrite-existing"
  }
}