# services/api-gateway/infrastructure/terraform/variables.tf

variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-west-2"
}

variable "stage_name" {
  description = "API Gateway deployment stage name"
  default     = "v1"
}

variable "get_applications_lambda_arn" {
  description = "ARN of the get applications Lambda function"
}

variable "create_application_lambda_arn" {
  description = "ARN of the create application Lambda function"
}

variable "get_application_lambda_arn" {
  description = "ARN of the get application Lambda function"
}

variable "update_application_lambda_arn" {
  description = "ARN of the update application Lambda function"
}

variable "delete_application_lambda_arn" {
  description = "ARN of the delete application Lambda function"
}

# Add other Lambda ARN variables for other services