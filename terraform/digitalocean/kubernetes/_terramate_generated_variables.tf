// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

variable "do_token" {
  default     = ""
  description = "DigitalOcean API token"
  type        = string
}
variable "project_name" {
  default     = "demonix"
  description = "The name of the project used for resource tagging and naming"
  type        = string
}
variable "environment" {
  default     = "development"
  description = "Deployment environment (e.g., development, staging, production)"
  type        = string
}
variable "deploy_region" {
  default     = "nyc2"
  description = "The cloud region where resources will be deployed"
  type        = string
}
variable "service_name" {
  default     = "portal"
  description = "The name of the specific service or component being deployed"
  type        = string
}
variable "vpc_cidr" {
  default     = "10.99.0.0/16"
  description = "The CIDR block for the Virtual Private Cloud"
  type        = string
}
locals {
}
