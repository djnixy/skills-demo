variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "region" {
  description = "The DigitalOcean region to deploy into"
  type        = string
  default     = "syd1"
}

variable "droplet_size" {
  description = "The droplet size to use"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "image_slug" {
  description = "The image slug to use for the droplet"
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "ssh_key_name" {
  description = "Name of the existing SSH key in DigitalOcean"
  type        = string
}

variable "project_name" {
  description = "Name of the DigitalOcean project to assign resources to"
  type        = string
  default     = ""
}
