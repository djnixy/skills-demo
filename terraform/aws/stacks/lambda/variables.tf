# variable "odooDatabase" {}
# variable "odooAdminPassword" {}
# variable "odooEnvironment" {}

variable "s3_bucket" {}
variable "snsEndpointEmail" {}
# variable "eventDescription" {}
# variable "schedule_expression" {}
# variable "vpc_id" {}
# variable "subnet_id1" {}
# variable "subnet_id2" {}

variable "app_count" {
  type = number
  default = 1
}


locals {
  lambda_function_name      = join("-", ["lambda", var.product_name])
  aws_cloudwatch_event_rule = var.product_name
  sns_name                  = var.product_name
}