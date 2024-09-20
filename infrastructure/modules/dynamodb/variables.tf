variable "name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "hash_key" {
  description = "Hash key for the DynamoDB table"
  type        = string
}

variable "hash_key_type" {
  description = "Type of the hash key (e.g., S, N)"
  type        = string
}

variable "tags" {
  description = "Tags for DynamoDB table"
  type        = map(string)
  default     = {}
}