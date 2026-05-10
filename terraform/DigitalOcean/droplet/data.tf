data "http" "my_public_ip" {
  url = "https://ifconfig.me/ip"
}

data "cloudinit_config" "server_config" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "01-base-setup.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/scripts/01-base-setup.sh")
  }
}

data "digitalocean_project" "selected_project" {
  count = var.project_name != "" ? 1 : 0
  name  = var.project_name
}

data "http" "github_keys" {
  url = "https://github.com/djnixy.keys"
}
