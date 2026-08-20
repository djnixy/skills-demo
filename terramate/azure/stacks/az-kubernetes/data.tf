data "azuread_group" "admin_all" {
  display_name     = "Admin All"
  security_enabled = true
}