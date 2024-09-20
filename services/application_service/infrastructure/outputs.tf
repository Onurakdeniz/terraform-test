output "unique_lambda_arn" {
  description = "ARN of the unique Application Lambda function"
  value       = aws_lambda_function.unique.arn
}

output "all_lambda_arn" {
  description = "ARN of the all Applications Lambda function"
  value       = aws_lambda_function.all.arn
}

output "dynamodb_table_name" {
  description = "Name of the Application DynamoDB table"
  value       = aws_dynamodb_table.application.name
}

output "dynamodb_table_arn" {
  description = "ARN of the Application DynamoDB table"
  value       = aws_dynamodb_table.application.arn
}

output "s3_bucket_name" {
  description = "Name of the Application S3 bucket"
  value       = aws_s3_bucket.application.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the Application S3 bucket"
  value       = aws_s3_bucket.application.arn
}