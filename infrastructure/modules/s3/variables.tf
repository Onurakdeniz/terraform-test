variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "policy_statements" {
  description = "S3 bucket policy statements"
  type = list(object({
    Effect    = string
    Action    = list(string)
    Resource  = list(string)
    Principal = any
  }))
  default = []
}

variable "tags" {
  description = "Tags for S3 bucket"
  type        = map(string)
  default     = {}
}