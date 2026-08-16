



variable "app_count" {
  type    = number
  default = 1
}

variable "create_efs" {
  type    = bool
  default = "false"
}


variable "dbAdminUser" {
  type    = string
  default = "postgres"
}

variable "dbAdminPassword" {
  type    = string
  default = "postgres"
}

variable "role_name_prefix" {
  description = "Prefix for IAM role names"
  type        = string
  default     = "default-prefix"
}

