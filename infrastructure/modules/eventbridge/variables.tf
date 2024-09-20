variable "name" {
  description = "Name of the EventBridge bus"
  type        = string
}

variable "application_target_arn" {
  description = "ARN of the target for application service events"
  type        = string
}

variable "files_target_arn" {
  description = "ARN of the target for files service events"
  type        = string
}

variable "tags" {
  description = "Tags for EventBridge"
  type        = map(string)
  default     = {}
}