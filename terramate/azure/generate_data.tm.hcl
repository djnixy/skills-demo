
# The backend configuration is the same in each stack, so we can generate it unconditionally

generate_hcl "_terramate_generated_data.tf" {
  content {

    data "http" "myip" {
      url = "https://ifconfig.me/ip"
    }
    data "azurerm_subscription" "current" {}
  }
}
