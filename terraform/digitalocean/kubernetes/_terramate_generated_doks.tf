// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "digitalocean_kubernetes_cluster" "main" {
  name    = var.environment
  region  = var.deploy_region
  version = "latest"
  maintenance_policy {
    day        = "tuesday"
    start_time = "03:00"
  }
  node_pool {
    auto_scale = true
    labels = {
      key   = "workload"
      value = "application"
    }
    max_nodes = 2
    min_nodes = 1
    name      = "def-medium"
    size      = "s-2vcpu-4gb"
  }
}
resource "digitalocean_kubernetes_node_pool" "def_large" {
  cluster_id = digitalocean_kubernetes_cluster.main.id
  labels = {
    key   = "workload"
    value = "application"
  }
  name       = "def-large"
  node_count = 0
  size       = "s-4vcpu-8gb"
}
resource "digitalocean_kubernetes_node_pool" "db_medium" {
  cluster_id = digitalocean_kubernetes_cluster.main.id
  labels = {
    key   = "workload"
    value = "database"
  }
  name       = "db-medium"
  node_count = 0
  size       = "s-2vcpu-4gb"
  taint {
    effect = "NoSchedule"
    key    = "workload"
    value  = "database"
  }
}
