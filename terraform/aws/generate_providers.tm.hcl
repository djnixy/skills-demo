generate_hcl "_terramate_generated_providers.tf" {
  content {

terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/aws/latest
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.64.0"
    }
    # https://registry.terraform.io/providers/hashicorp/kubernetes/latest
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }
  }
}

provider "aws" {
    region       = var.deploy_region
    profile      = "niki"
    # skip_credentials_validation = true
    # skip_requesting_account_id  = true
    # skip_metadata_api_check     = true
    # # s3_force_path_style         = true
    # access_key                  = "mock_access_key"
    # secret_key                  = "mock_secret_key"

    default_tags {
        tags = {
            Environment = var.environment
            Project     = var.project_name
        }
    }
}

  }
}


