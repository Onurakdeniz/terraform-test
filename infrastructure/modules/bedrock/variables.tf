variable "output_bucket" {
  description = "The S3 bucket for output data"
  type        = string
}

variable "training_bucket" {
  description = "The S3 bucket for training data"
  type        = string
}

variable "endpoint_name" {
  description = "The name of the Bedrock endpoint"
  type        = string
}

variable "model_name" {
  description = "The name of the Bedrock model"
  type        = string
}

variable "model_type" {
  description = "The type of the Bedrock model"
  type        = string
}