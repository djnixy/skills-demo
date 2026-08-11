// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.99.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.2.0"
    }
  }
}
provider "digitalocean" {
  token = var.do_token
}
provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)
    host                   = digitalocean_kubernetes_cluster.main.endpoint
    token                  = digitalocean_kubernetes_cluster.main.kube_config[0].token
  }
}
