variable "name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "filename" {
  description = "The deployment package for the Lambda function"
  type        = string
}

variable "handler" {
  description = "The handler for the Lambda function"
  type        = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function"
  type        = string
}

variable "policy_statements" {
  description = "IAM policy statements for Lambda"
  type = list(object({
    Effect   = string
    Action   = list(string)
    Resource = list(string)
  }))
  default = []
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "source_arn" {
  description = "The ARN of the source that can invoke the Lambda function"
  type        = string
}

variable "tags" {
  description = "Tags for Lambda resources"
  type        = map(string)
  default     = {}
}