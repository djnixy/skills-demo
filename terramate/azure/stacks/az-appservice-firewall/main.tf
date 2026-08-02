resource "azurerm_resource_group" "this" {
  name     = local.rgName
  location = var.region
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.99.0.0/16"]
  location            = azurerm_resource_group.this.location
  name                = local.vnetName
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "a" {
  address_prefixes                               = ["10.99.0.0/20"]
  name                                           = "snet-hosts-a"
  resource_group_name                            = azurerm_resource_group.this.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet" "b" {
  address_prefixes                               = ["10.99.16.0/20"]
  name                                           = "snet-hosts-b"
  resource_group_name                            = azurerm_resource_group.this.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name

}

resource "azurerm_subnet" "database" {
  address_prefixes                               = ["10.99.240.0/20"]
  name                                           = "snet-database-a"
  resource_group_name                            = azurerm_resource_group.this.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

# resource "azurerm_web_application_firewall_policy" "this" {
#   name = local.waf_policy_name
#   resource_group_name = azurerm_resource_group.this.name
#   location = azurerm_resource_group.this.location

#   policy_settings {
#     enabled = true
#     mode = "Prevention"
#     file_upload_limit_in_mb = 100
#     request_body_check = true
#     request_body_inspect_limit_in_kb = 100

#   }
#   managed_rules {
#     managed_rule_set {
#       type    = "OWASP"
#       version = "3.2"
#     }
#   }
# }

resource "azurerm_public_ip" "this" {
  name                = local.public_ip_address_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
  zones               = [1,2]
}



