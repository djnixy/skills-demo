
# The backend configuration is the same in each stack, so we can generate it unconditionally

generate_hcl "_terramate_generated_outputs.tf" {
  content {

    output "current_subscription_display_name" {
      value = data.azurerm_subscription.current.display_name
    }
  }
}
