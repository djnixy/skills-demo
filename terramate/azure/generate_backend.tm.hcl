
# The backend configuration is the same in each stack, so we can generate it unconditionally

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "local" {
        path = "terraform.tfstate"
      }
      # backend "azurerm" {
      #   resource_group_name  = "rg-shared"
      #   storage_account_name = "stdemosample"
      #   container_name       = "terraform-state"
      #   key                  = "stacks/by-id/${terramate.stack.id}/terraform.tfstate"
      # }
    }
  }
}
