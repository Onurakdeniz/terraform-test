output "get_applications_lambda_arn" {
  value = aws_lambda_function.get_applications.arn
}

output "create_application_lambda_arn" {
  value = aws_lambda_function.create_application.arn
}

output "get_application_lambda_arn" {
  value = aws_lambda_function.get_application.arn
}

output "update_application_lambda_arn" {
  value = aws_lambda_function.update_application.arn
}

output "delete_application_lambda_arn" {
  value = aws_lambda_function.delete_application.arn
}