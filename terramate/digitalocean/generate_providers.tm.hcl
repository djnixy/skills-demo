generate_hcl "_terramate_generated_providers.tf" {
  content {

    terraform {
      required_providers {
        # https://registry.terraform.io/providers/digitalocean/digitalocean/latest
        digitalocean = {
          source  = "digitalocean/digitalocean"
          version = "~> 2.36.0"
        }
        # https://registry.terraform.io/providers/hashicorp/kubernetes/latest
        kubernetes = {
          source  = "hashicorp/kubernetes"
          version = "~> 2.32.0"
        }
        # https://registry.terraform.io/providers/hashicorp/helm/latest
        helm = {
          source  = "hashicorp/helm"
          version = "~> 2.15.0"
        }
      }
    }
    
    provider "digitalocean" {
        token = var.do_token
    }

    provider "kubernetes" {
      host  = digitalocean_kubernetes_cluster.main.endpoint
      token = digitalocean_kubernetes_cluster.main.kube_config[0].token
      cluster_ca_certificate = base64decode(
        digitalocean_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
      )
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


