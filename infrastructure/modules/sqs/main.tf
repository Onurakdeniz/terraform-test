resource "aws_sqs_queue" "application_to_files" {
  name                      = var.application_to_files_queue_name
  fifo_queue                = false
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 20

  tags = var.tags
}

resource "aws_sqs_queue_policy" "application_to_files_policy" {
  queue_url = aws_sqs_queue.application_to_files.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:*"
        Resource  = aws_sqs_queue.application_to_files.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = var.application_source_arn
          }
        }
      }
    ]
  })
}