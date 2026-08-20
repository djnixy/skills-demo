generate_hcl "_terramate_generated_providers.tf" {
  content {
    terraform {
      required_version = ">= 1.15.2"
      required_providers {
        # https://registry.terraform.io/providers/hashicorp/azurerm/latest
        azurerm = {
          source  = "hashicorp/azurerm"
          version = ">= 4.48.0, < 5.0.0"
        }
        # https://registry.terraform.io/providers/hashicorp/kubernetes/latest
        azapi = {
          source  = "azure/azapi"
          version = ">= 2.0.0, < 3.0.0"
        }
        azuread = {
          source  = "hashicorp/azuread"
          version = "~> 3.0"
        }
      }
    }

    provider "azuread" {}

    provider "azurerm" {
      features {}
      subscription_id = "46cd81e4-c227-4a47-89ad-fc83875fe4d6"
    }
  }
}
