generate_hcl "_terramate_generated_doks.tf" {
  content {
    resource "digitalocean_kubernetes_cluster" "main" {
      name    = var.environment
      region  = var.deploy_region
      version = "latest"
      maintenance_policy {
        start_time = "22:00"
        day        = "monday"
      }
      node_pool {
        name       = "def-medium"
        size       = "s-2vcpu-4gb"
        auto_scale = true
        min_nodes  = 1
        max_nodes  = 2

        labels = {
          key   = "workload"
          value = "application"
        }
      }
    }

    resource "digitalocean_kubernetes_node_pool" "def_large" {
      cluster_id = digitalocean_kubernetes_cluster.main.id
      name       = "def-large"
      size       = "s-4vcpu-8gb"
      node_count = 0

      labels = {
        key   = "workload"
        value = "application"
      }
    }

    resource "digitalocean_kubernetes_node_pool" "db_medium" {
      cluster_id = digitalocean_kubernetes_cluster.main.id
      name       = "db-medium"
      size       = "s-2vcpu-4gb"
      node_count = 0

      labels = {
        key   = "workload"
        value = "database"
      }

      taint {
        key    = "workload"
        value  = "database"
        effect = "NoSchedule"
      }
    }
  }
}