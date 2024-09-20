variable "name" {
  description = "Name of the Application service"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, test, prod)"
  type        = string
}

variable "lambda_unique_filename" {
  description = "Path to the unique Application Lambda deployment package"
  type        = string
}

variable "lambda_unique_handler" {
  description = "Handler for the unique Application Lambda function"
  type        = string
}

variable "lambda_all_filename" {
  description = "Path to the all Applications Lambda deployment package"
  type        = string
}

variable "lambda_all_handler" {
  description = "Handler for the all Applications Lambda function"
  type        = string
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda functions"
  type        = string
  default     = "nodejs18.x"
}

variable "policy_statements" {
  description = "IAM policy statements for Lambda functions"
  type = list(object({
    Effect   = string
    Action   = list(string)
    Resource = list(string)
  }))
}

variable "environment_variables" {
  description = "Environment variables for Lambda functions"
  type        = map(string)
  default     = {}
}

variable "api_gateway_source_arn" {
  description = "Source ARN for API Gateway to invoke Lambda"
  type        = string
}

variable "event_bus_name" {
  description = "Name of the EventBridge bus"
  type        = string
}

variable "event_pattern" {
  description = "Event pattern for EventBridge rule"
  type        = string
}

variable "log_retention_days" {
  description = "Retention period for CloudWatch Logs in days"
  type        = number
  default     = 14
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrent executions for Lambda functions"
  type        = number
  default     = 100
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}