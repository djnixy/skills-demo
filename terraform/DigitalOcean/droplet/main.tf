resource "digitalocean_firewall" "server_fw" {
  name = "server-fw"

  droplet_ids = [digitalocean_droplet.server.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8069"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}


resource "digitalocean_ssh_key" "github_key" {
  name       = var.ssh_key_name
  public_key = split("\n", trimspace(data.http.github_keys.response_body))[0]
}

resource "digitalocean_droplet" "server" {
  image  = var.image_slug
  name   = "server"
  region = var.region
  size   = var.droplet_size

  user_data = data.cloudinit_config.server_config.rendered
  ssh_keys  = [digitalocean_ssh_key.github_key.id]
  tags      = ["development"]
}

resource "digitalocean_project_resources" "project_assignment" {
  count   = var.project_name != "" ? 1 : 0
  project = data.digitalocean_project.selected_project[0].id
  resources = [
    digitalocean_droplet.server.urn
  ]
}
