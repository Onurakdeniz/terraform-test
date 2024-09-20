variable "region" {
  type        = string
  description = "The AWS region to deploy resources"
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, staging, prod)"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "AWS Secret Access Key"
}

variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "AWS Access Key ID"
}