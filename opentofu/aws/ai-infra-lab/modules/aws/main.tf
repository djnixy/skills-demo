variable "bucket_name" {
  type = string
}

variable "queue_name" {
  type = string
}

resource "aws_s3_bucket" "docs_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "docs_bucket_access" {
  bucket = aws_s3_bucket.docs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls     = true
  restrict_public_buckets = true
}

resource "aws_sqs_queue" "processing_queue" {
  name                      = var.queue_name
  message_retention_seconds = 345600
  visibility_timeout_seconds = 30
}

resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = aws_sqs_queue.processing_queue.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "s3.amazonaws.com" }
      Action = "sqs:SendMessage"
      Resource = aws_sqs_queue.processing_queue.arn
      Condition = {
        ArnEquals = { "aws:SourceArn": aws_s3_bucket.docs_bucket.arn }
      }
    }]
  })
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.docs_bucket.id
  queue {
    queue_arn = aws_sqs_queue.processing_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }
}
