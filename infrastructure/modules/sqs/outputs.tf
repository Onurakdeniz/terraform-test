output "application_to_files_queue_url" {
  description = "URL of the Application to Files SQS queue"
  value       = aws_sqs_queue.application_to_files.id
}

output "application_to_files_queue_arn" {
  description = "ARN of the Application to Files SQS queue"
  value       = aws_sqs_queue.application_to_files.arn
}