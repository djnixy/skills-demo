
# generate_hcl "_terramate_generated_locals.tf" {
#   lets {
#     # environment = tm_regex("^/environments/([^/]+)/", terramate.stack.path.absolute)[0]
#     product_name = tm_regex("^/stacks/([a-z,1-100]+)", terramate.stack.path.absolute)[0]
#   }

#   content {
#     locals {
#       # environment = let.environment
#       product_name = let.product_name
#       azs      = slice(data.aws_availability_zones.available.names, 0, 2)
#       ecsTaskExecutionRole  = join("", ["arn:aws:iam::", data.aws_caller_identity.current.account_id, ":role/ecsTaskExecutionRole"])
#       monitoring_role_arn   = join("", ["arn:aws:iam::", data.aws_caller_identity.current.account_id, ":role/rds-monitoring-role"])

#     }
#   }
# }
