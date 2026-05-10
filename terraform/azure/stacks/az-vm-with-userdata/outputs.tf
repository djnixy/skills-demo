output "vm_public_ip_address" {
  value = azurerm_public_ip.this.ip_address
}

output "vm_public_ip_address_data" {
  value = data.azurerm_public_ip.this.ip_address
}


