generate_hcl "_terramate_generated_providers.tf" {
  content {

terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/aws/latest
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.60.0"
    }
    # https://registry.terraform.io/providers/hashicorp/kubernetes/latest
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.2.1"
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

provider "kubernetes" {
  host =  module.eks.cluster_endpoint
  token                  = module.eks.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    # aws_eks_cluster.my-cluster.certificate_authority.0.data)
}

  }
}


