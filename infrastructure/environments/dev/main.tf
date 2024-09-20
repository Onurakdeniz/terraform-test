provider "aws" {
  region = var.region
}
module "application_service" {
  source = "../../../services/application_service/infrastructure"

  name                   = "application-service"
  environment            = "dev"
  lambda_unique_filename = "../../functions/application_unique.zip"
  lambda_unique_handler  = "application_unique.handler"
  lambda_all_filename    = "../../functions/application_all.zip"
  lambda_all_handler     = "application_all.handler"
  lambda_runtime         = "nodejs18.x"
  policy_statements = [
    {
      Effect = "Allow",
      Action = [
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      Resource = [module.application_service.dynamodb_table_arn]
    },
    {
      Effect = "Allow",
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      Resource = [module.application_service.s3_bucket_arn]
    },
    {
      Effect = "Allow",
      Action = [
        "events:PutEvents"
      ],
      Resource = ["*"]
    }
  ]
  environment_variables = {
    ENVIRONMENT = "dev"
    LOG_LEVEL   = "DEBUG"
  }
  api_gateway_source_arn = module.api_gateway.invoke_url
  event_bus_name         = module.eventbridge.event_bus_name
  event_pattern = jsonencode({
    "source" : ["application.service"]
  })
  log_retention_days             = 14
  reserved_concurrent_executions = 100
  tags = {
    Environment = "dev"
    Project     = "YourProjectName"
  }
}

module "file_service" {
  source = "../../../services/file_service/infrastructure"

  name                   = "file-service"
  environment            = "dev"
  lambda_unique_filename = "../../functions/file_unique.zip"
  lambda_unique_handler  = "file_unique.handler"
  lambda_all_filename    = "../../functions/file_all.zip"
  lambda_all_handler     = "file_all.handler"
  lambda_runtime         = "nodejs18.x"
  policy_statements = [
    {
      Effect = "Allow",
      Action = [
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      Resource = [module.file_service.dynamodb_table_arn]
    },
    {
      Effect = "Allow",
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      Resource = [module.file_service.s3_bucket_arn]
    },
    {
      Effect = "Allow",
      Action = [
        "events:PutEvents"
      ],
      Resource = ["*"]
    }
  ]
  environment_variables = {
    ENVIRONMENT = "dev"
    LOG_LEVEL   = "DEBUG"
  }
  api_gateway_source_arn = module.api_gateway.invoke_url
  event_bus_name         = module.eventbridge.event_bus_name
  event_pattern = jsonencode({
    "source" : ["files.service"]
  })
  log_retention_days             = 14
  reserved_concurrent_executions = 100
  tags = {
    Environment = "dev"
    Project     = "YourProjectName"
  }
}

module "api_gateway" {
  source             = "../../modules/api_gateway"
  name               = "api-gateway"
  description        = "API Gateway for Development Environment"
  binary_media_types = []
  resources = {
    "applications" = { path_part = "applications" }
    "files"        = { path_part = "files" }
  }
  methods = {
    "applications" = { http_method = "GET", authorization = "NONE" }
    "files"        = { http_method = "GET", authorization = "NONE" }
  }
  integrations = {
    "applications" = { lambda_arn = module.application_service.unique_lambda_arn }
    "files"        = { lambda_arn = module.file_service.unique_lambda_arn }
  }
  stage_name = "dev"
  tags = {
    Environment = "dev"
    Project     = "YourProjectName"
  }
}

module "eventbridge" {
  source                 = "../../modules/eventbridge"
  name                   = "event-bus"
  application_target_arn = module.application_service.unique_lambda_arn
  files_target_arn       = module.file_service.unique_lambda_arn
  tags = {
    Environment = "dev"
    Project     = "YourProjectName"
  }
}

module "sqs" {
  source                          = "../../modules/sqs"
  application_to_files_queue_name = "app-to-files-dev-queue"
  application_source_arn          = module.api_gateway.invoke_url
  tags = {
    Environment = "dev"
    Project     = "YourProjectName"
  }
}

module "bedrock" {
  source          = "../../modules/bedrock"
  output_bucket   = "example-output-bucket"
  training_bucket = "example-training-bucket"

  # Add the missing required variables
  endpoint_name = "dev-bedrock-endpoint"
  model_name    = "dev-bedrock-model"
  model_type    = "standard"  # Replace with the appropriate model type
}