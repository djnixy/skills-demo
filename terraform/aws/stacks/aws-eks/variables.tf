

# variable "product_name" {}

# variable "vpc_id" {}
# variable "vpc_cidr" {}
# variable "azs" {}
# variable "subnet_id1" {}
# variable "subnet_id2" {}
# variable "existing_alb_name" {}
# variable "existing_alb_securitygroup_name" {}

# variable "listener_arn" {}
# variable "domain_name1" {}
# variable "domain_name2" {}

variable "app_count" {
  type    = number
  default = 1
}

# variable "service_name1" {}
# variable "service_name2" {}
variable "create_efs" {
  type    = bool
  default = "false"
}


# variable "existing_efs_id" {}
# variable "existing_efs_access_point_id" {}
variable "dbAdminUser" {
  type    = string
  default = "postgres"
}

variable "dbAdminPassword" {
  type    = string
  default = "postgres"
}
# variable "dbPassword" {
#   validation {
#     condition     = length(var.dbPassword) > 23
#     error_message = "Password length must be 24 characters or more"
#   }
#   default = "piZ8BCZSksSbRpnWsi8Ya44QwzuJby"
# }

# variable "db_subnet_group_name" {}


variable "role_name_prefix" {
  description = "Prefix for IAM role names"
  type        = string
  default     = "default-prefix" # Set a meaningful default value
}

