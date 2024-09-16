# services/api-gateway/infrastructure/terraform/outputs.tf

output "api_url" {
  description = "URL of the deployed API"
  value       = "${aws_api_gateway_deployment.main.invoke_url}${var.stage_name}"
}

output "execution_arn" {
  description = "Execution ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.main.execution_arn
}