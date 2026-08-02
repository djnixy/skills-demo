generate_hcl "_terramate_generated_providers.tf" {
  content {
    terraform {
      required_providers {
        # https://registry.terraform.io/providers/hashicorp/azurerm/latest
        azurerm = {
          source  = "hashicorp/azurerm"
          # version = "4.0.1"
        }
        # https://registry.terraform.io/providers/hashicorp/kubernetes/latest
        kubernetes = {
          source  = "hashicorp/kubernetes"
          version = "~> 2.32.0"
        }
      }
      required_version = ">= 1.9.3"
    }

    provider "azurerm" {
      features {}

      # client_id       = "00000000-0000-0000-0000-000000000000"
      # client_secret   = var.client_secret
      # tenant_id       = "10000000-0000-0000-0000-000000000000"
      subscription_id = "6e8e6b22-9037-4bd9-aa63-143e7b16e31c" #Microsoft Partner Network
      # subscription_id = "c69b36ac-dd24-451a-85e2-45cb75a29c38" #FLEXIDEV
    }
    provider "kubernetes" {
      host                   = module.aks.host
      client_certificate     = base64decode(module.aks.client_certificate)
      client_key             = base64decode(module.aks.client_key)
      cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
    }
  }
}


