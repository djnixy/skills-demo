output "public_ip" {
  value = "http://${digitalocean_droplet.server.ipv4_address}"
}
