
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

# # output "security_group_arn" {
# #   description = "The ARN of the security group"
# #   value       = module.http_sg.security_group_arn
# # }

# output "aws_region" {
#   value = data.aws_region.current
# }
