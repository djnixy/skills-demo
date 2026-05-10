terraform {
  required_version = ">= 1.0.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.48.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}
