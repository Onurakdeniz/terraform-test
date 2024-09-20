resource "aws_api_gateway_rest_api" "this" {
  name               = var.name
  description        = var.description
  binary_media_types = var.binary_media_types

  tags = var.tags
}

resource "aws_api_gateway_resource" "resources" {
  for_each    = var.resources
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = each.key
}

resource "aws_api_gateway_method" "methods" {
  for_each      = var.methods
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.resources[each.key].id
  http_method   = each.value.http_method
  authorization = each.value.authorization
}

resource "aws_api_gateway_integration" "integrations" {
  for_each                = var.integrations
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.resources[each.key].id
  http_method             = aws_api_gateway_method.methods[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = each.value.lambda_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.integrations
  ]
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = var.stage_name
}

output "invoke_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}

resource "aws_api_gateway_stage" "stage" {
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.deployment.id

  tags = var.tags
}