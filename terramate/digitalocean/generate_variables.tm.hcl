generate_hcl "_terramate_generated_variables.tf" {
  content {

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "The name of the project used for resource tagging and naming"
  type        = string
  default = "demonix"
}

variable "environment" {
  description = "Deployment environment (e.g., development, staging, production)"
  type        = string
  default = "development"
}

variable "deploy_region" {
  description = "The cloud region where resources will be deployed"
  type        = string
  default = "nyc2"
}

variable "service_name" {
  description = "The name of the specific service or component being deployed"
  type        = string
  default = "portal"
}

variable "vpc_cidr" {
  description = "The CIDR block for the Virtual Private Cloud"
  type        = string
  default = "10.99.0.0/16"
}

locals {

}




  }
}
