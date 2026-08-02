# resource "aws_sns_topic" "success_reporting" {
#   name = "${local.sns_name}-success-topic"
# }

# resource "aws_sns_topic" "error_reporting" {
#   name = "${local.sns_name}-error-topic"
# }

# resource "aws_sns_topic_subscription" "success-email-target" {
#   topic_arn = aws_sns_topic.success_reporting.arn
#   protocol  = "email"
#   endpoint  = var.snsEndpointEmail
# }

# resource "aws_sns_topic_subscription" "error-email-target" {
#   topic_arn = aws_sns_topic.error_reporting.arn
#   protocol  = "email"
#   endpoint  = var.snsEndpointEmail
# }
