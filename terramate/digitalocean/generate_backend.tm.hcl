
# The backend configuration is the same in each stack, so we can generate it unconditionally

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket  = "myterraform"
        key     = "stacks/by-id/${terramate.stack.id}/terraform.tfstate"
        region  = "us-east-1"
        endpoints = {
          s3 = "https://105f99619ed4f3e51d671d452ca2e534.r2.cloudflarestorage.com"
        }
        skip_credentials_validation = true
        skip_region_validation      = true
        skip_requesting_account_id  = true
        skip_s3_checksum            = true
      }
    }
  }
}
