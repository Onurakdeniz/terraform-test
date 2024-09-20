variable "name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "description" {
  description = "Description of the API Gateway"
  type        = string
  default     = ""
}

variable "binary_media_types" {
  description = "List of binary media types"
  type        = list(string)
  default     = []
}

variable "resources" {
  description = "Map of resource paths and their configurations"
  type = map(object({
    path_part = string
  }))
  default = {}
}

variable "methods" {
  description = "Map of methods for each resource"
  type = map(object({
    http_method   = string
    authorization = string
  }))
  default = {}
}

variable "integrations" {
  description = "Map of integrations for each method"
  type = map(object({
    lambda_arn = string
  }))
  default = {}
}

variable "stage_name" {
  description = "Deployment stage name"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags for API Gateway"
  type        = map(string)
  default     = {}
}