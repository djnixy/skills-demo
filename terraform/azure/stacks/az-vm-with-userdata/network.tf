resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.99.0.0/16"]
  location            = azurerm_resource_group.this.location
  name                = "vnet-test" #local.vnetName
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "a" {
  address_prefixes                               = ["10.99.0.0/20"]
  name                                           = "snet-hosts-a"
  resource_group_name                            = azurerm_resource_group.this.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name

}

resource "azurerm_public_ip" "this" {
  name                = local.public_ip_address_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "this" {
  name                = local.network_interface_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.a.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

resource "azurerm_network_security_group" "this" {
  name                = local.network_security_group_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

}


resource "azurerm_network_security_rule" "ssh" {
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
  name                        = "ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = data.http.myip.body
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "specific" {
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
  name                        = "others"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1-10000"
  source_address_prefix       = data.http.myip.body
  destination_address_prefix  = "*"
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}