variable "zone_id" {
  type = string
}

variable "record_name" {
  type = string
  default = "ai"
}

variable "record_value" {
  type = string
}

resource "cloudflare_dns_record" "ai_endpoint" {
  zone_id = var.zone_id
  name    = var.record_name
  value   = var.record_value
  type    = "CNAME"
  ttl     = 3600
  proxied = true
}

output "dns_endpoint" {
  value = "${var.record_name}.nikiakbar.com"
}
