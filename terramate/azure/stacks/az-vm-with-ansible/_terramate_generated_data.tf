// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

data "http" "myip" {
  url = "https://ifconfig.me/ip"
}
data "azurerm_subscription" "current" {
}
data "azurerm_client_config" "current" {
}
