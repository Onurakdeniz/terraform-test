variable "region" {
  type        = string
  description = "The AWS region to deploy resources"
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, staging, prod)"
}