// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

terraform {
  backend "s3" {
    bucket = "myterraform"
    endpoints = {
      s3 = "https://105f99619ed4f3e51d671d452ca2e534.r2.cloudflarestorage.com"
    }
    key                         = "stacks/by-id/doks/terraform.tfstate"
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
