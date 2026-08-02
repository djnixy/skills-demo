resource "azurerm_resource_group" "this" {
  name     = local.rg_name
  location = var.region
}

resource "azurerm_linux_virtual_machine" "this" {
  name                  = local.virtual_machine_name
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  network_interface_ids = [azurerm_network_interface.this.id]
  size               = var.vm_size
  admin_username      = "ubuntu" #if you change this, you will need to change the ansible playbook as well
  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/id_rsa_primary.pub")
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    # storage_account_type = "Standard_LRS"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
    # disk_size_gb         = 40
    # disk_size_gb         = 64
    # disk_size_gb         = 128
  }

  # Add custom data to run apt update and upgrade
  # custom_data = base64encode(<<-EOF
  #   #!/bin/bash
  #   sudo apt update -y
  #   sudo apt upgrade -y
  # EOF
  # )
}