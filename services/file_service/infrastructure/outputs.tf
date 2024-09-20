output "unique_lambda_arn" {
  description = "ARN of the unique File Lambda function"
  value       = aws_lambda_function.unique.arn
}

output "all_lambda_arn" {
  description = "ARN of the all Files Lambda function"
  value       = aws_lambda_function.all.arn
}

output "dynamodb_table_name" {
  description = "Name of the File DynamoDB table"
  value       = aws_dynamodb_table.file.name
}

output "dynamodb_table_arn" {
  description = "ARN of the File DynamoDB table"
  value       = aws_dynamodb_table.file.arn
}

output "s3_bucket_name" {
  description = "Name of the File S3 bucket"
  value       = aws_s3_bucket.file.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the File S3 bucket"
  value       = aws_s3_bucket.file.arn
}