# services/api-gateway/infrastructure/terraform/main.tf

provider "aws" {
  region = var.aws_region
}

resource "aws_api_gateway_rest_api" "main" {
  name        = "visa-auto-api"
  description = "Main API Gateway for Visa Auto application"
}

# Application Service Resources
resource "aws_api_gateway_resource" "applications" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "applications"
}

resource "aws_api_gateway_resource" "application_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.applications.id
  path_part   = "{applicationId}"
}

# GET /applications
resource "aws_api_gateway_method" "get_applications" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.applications.id
  http_method   = "GET"
  authorization = "NONE"  # Update this based on your authentication method
}

resource "aws_api_gateway_integration" "get_applications" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.applications.id
  http_method = aws_api_gateway_method.get_applications.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_applications_lambda_arn
}

# POST /applications
resource "aws_api_gateway_method" "create_application" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.applications.id
  http_method   = "POST"
  authorization = "NONE"  # Update this based on your authentication method
}

resource "aws_api_gateway_integration" "create_application" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.applications.id
  http_method = aws_api_gateway_method.create_application.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.create_application_lambda_arn
}

# GET /applications/{applicationId}
resource "aws_api_gateway_method" "get_application" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.application_id.id
  http_method   = "GET"
  authorization = "NONE"  # Update this based on your authentication method
}

resource "aws_api_gateway_integration" "get_application" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.application_id.id
  http_method = aws_api_gateway_method.get_application.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_application_lambda_arn
}

# PUT /applications/{applicationId}
resource "aws_api_gateway_method" "update_application" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.application_id.id
  http_method   = "PUT"
  authorization = "NONE"  # Update this based on your authentication method
}

resource "aws_api_gateway_integration" "update_application" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.application_id.id
  http_method = aws_api_gateway_method.update_application.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.update_application_lambda_arn
}

# DELETE /applications/{applicationId}
resource "aws_api_gateway_method" "delete_application" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.application_id.id
  http_method   = "DELETE"
  authorization = "NONE"  # Update this based on your authentication method
}

resource "aws_api_gateway_integration" "delete_application" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.application_id.id
  http_method = aws_api_gateway_method.delete_application.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.delete_application_lambda_arn
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "main" {
  depends_on = [
    aws_api_gateway_integration.get_applications,
    aws_api_gateway_integration.create_application,
    aws_api_gateway_integration.get_application,
    aws_api_gateway_integration.update_application,
    aws_api_gateway_integration.delete_application,
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = var.stage_name
}

# Add other service integrations here (e.g., auth, user, etc.)