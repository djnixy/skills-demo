
generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "argocd_nikiakbar_password" {
      value     = random_password.nikiakbar_password.result
      sensitive = true
    }
    output "argocd_password" {
      value = nonsensitive(random_password.nikiakbar_password.result)
    }
    output "cluster_id" {
      description = "The ID of the DigitalOcean Kubernetes cluster"
      value       = digitalocean_kubernetes_cluster.main.id
    }

    output "cluster_endpoint" {
      description = "The endpoint for the Kubernetes cluster"
      value       = digitalocean_kubernetes_cluster.main.endpoint
    }

    output "cluster_status" {
      description = "The status of the Kubernetes cluster"
      value       = digitalocean_kubernetes_cluster.main.status
    }
  }
}
