generate_hcl "_terramate_generated_providers.tf" {
  content {

terraform {
  required_providers {
    # https://registry.terraform.io/providers/digitalocean/digitalocean/latest
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.99.0"
    }
    # https://registry.terraform.io/providers/hashicorp/kubernetes/latest
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.2.0"
    }
  }
}

provider "digitalocean" {
    token = var.do_token
}

provider "helm" {
      kubernetes {
        host  = digitalocean_kubernetes_cluster.main.endpoint
        token = digitalocean_kubernetes_cluster.main.kube_config[0].token
        cluster_ca_certificate = base64decode(
        digitalocean_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
        )
      }
      }
  }
}


