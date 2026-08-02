terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  
  backend "remote" {
    organization = "nixy-org"

    workspaces {
      name = "aws-ecs-1-workspace"
    }
  }
}

