variable "application_to_files_queue_name" {
  description = "Name of the SQS queue from Application to Files service"
  type        = string
}

variable "application_source_arn" {
  description = "Source ARN that can send messages to the SQS queue"
  type        = string
}

variable "tags" {
  description = "Tags for SQS queues"
  type        = map(string)
  default     = {}
}