resource "aws_cloudwatch_event_bus" "this" {
  name = var.name
  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "application_events" {
  name           = "${var.name}-application-rule"
  event_bus_name = aws_cloudwatch_event_bus.this.name
  event_pattern  = jsonencode({
    "source" : ["application.service"]
  })
  description = "Rule to capture application service events"
}

resource "aws_cloudwatch_event_target" "application_target" {
  rule           = aws_cloudwatch_event_rule.application_events.name
  event_bus_name = aws_cloudwatch_event_bus.this.name
  arn            = var.application_target_arn
}

output "event_bus_name" {
  description = "Name of the EventBridge bus"
  value       = aws_cloudwatch_event_bus.this.name
}

output "event_bus_arn" {
  description = "ARN of the EventBridge bus"
  value       = aws_cloudwatch_event_bus.this.arn
}