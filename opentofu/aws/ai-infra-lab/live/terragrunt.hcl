locals {
  aws_region = "us-east-1"
}

# Configure remote state for all components in this hierarchy
remote_state {
  backend = "s3"
  config = {
    bucket = "my-ai-infra-state-bucket" # Replace with your actual bucket
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = local.aws_region
    encrypt = true
    dynamodb_table = "terraform-locks"
  }
}

# Generate the provider block for all children
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
}

provider "cloudflare" {
  # API key is read from environment variables
}
EOF
}
