locals {
  service_prefix = "${var.environment}-${var.name}"
}

resource "aws_dynamodb_table" "application" {
  name         = "${var.name}-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }

  tags = var.tags
}

resource "aws_s3_bucket" "application" {
  bucket = "${var.name}-bucket"
  tags   = var.tags
}


module "lambda_unique" {
  source                = "../../../infrastructure/modules/lambda"
  name                  = "${var.name}-unique"
  filename              = var.lambda_unique_filename
  handler               = var.lambda_unique_handler
  runtime               = var.lambda_runtime
  environment_variables = merge(var.environment_variables, {
    TABLE_NAME  = aws_dynamodb_table.application.name
    BUCKET_NAME = aws_s3_bucket.application.bucket
  })
  source_arn            = var.api_gateway_source_arn
  tags                  = var.tags
}

resource "aws_s3_bucket_versioning" "application" {
  bucket = aws_s3_bucket.application.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "application" {
  bucket = aws_s3_bucket.application.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "application" {
  bucket = aws_s3_bucket.application.id

  rule {
    id     = "ExpireOldVersions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "application" {
  bucket = aws_s3_bucket.application.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "application" {
  depends_on = [aws_s3_bucket_ownership_controls.application]

  bucket = aws_s3_bucket.application.id
  acl    = "private"
}

module "lambda_all" {
  source                = "../../../infrastructure/modules/lambda"
  name                  = "${var.name}-all"
  filename              = var.lambda_all_filename
  handler               = var.lambda_all_handler
  runtime               = var.lambda_runtime
  environment_variables = merge(var.environment_variables, {
    TABLE_NAME  = aws_dynamodb_table.application.name
    BUCKET_NAME = aws_s3_bucket.application.bucket
  })
  source_arn            = var.api_gateway_source_arn
  tags                  = var.tags
}

resource "aws_iam_role" "lambda_role" {
  name = "${local.service_prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })

  tags = merge(var.tags, {
    Service     = var.name
    Environment = var.environment
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${local.service_prefix}-lambda-policy"
  description = "IAM policy for ${local.service_prefix} Lambda functions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement: var.policy_statements
  })

  tags = merge(var.tags, {
    Service     = var.name
    Environment = var.environment
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_permission" "api_gateway_unique" {
  statement_id  = "AllowAPIGatewayInvokeUnique"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_unique.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.api_gateway_source_arn
}

resource "aws_lambda_permission" "api_gateway_all" {
  statement_id  = "AllowAPIGatewayInvokeAll"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_all.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.api_gateway_source_arn
}

resource "aws_cloudwatch_log_group" "unique" {
  name              = "/aws/lambda/${module.lambda_unique.lambda_name}"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Service     = var.name
    Environment = var.environment
  })
}

resource "aws_cloudwatch_log_group" "all" {
  name              = "/aws/lambda/${module.lambda_all.lambda_name}"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Service     = var.name
    Environment = var.environment
  })
}

resource "aws_dynamodb_table_item" "example" {
  table_name = aws_dynamodb_table.application.name
  hash_key   = "ApplicationID"

  item = jsonencode({
    ApplicationID = { "S" = "example-id" }
    Name          = { "S" = "Example Application" }
  })
}

resource "aws_s3_bucket_notification" "unique" {
  bucket = aws_s3_bucket.application.id

  lambda_function {
    lambda_function_arn = module.lambda_unique.lambda_arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".json"
  }

  depends_on = [aws_lambda_permission.api_gateway_unique]
}

resource "aws_s3_bucket_notification" "all" {
  bucket = aws_s3_bucket.application.id

  lambda_function {
    lambda_function_arn = module.lambda_all.lambda_arn
    events              = ["s3:ObjectRemoved:*"]
    filter_suffix       = ".json"
  }

  depends_on = [aws_lambda_permission.api_gateway_all]
}

resource "aws_iam_role_policy" "lambda_logging" {
  name   = "${local.service_prefix}-lambda-logging-policy"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_logging.json
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:*:*:*"]
    effect    = "Allow"
  }
}

resource "aws_cloudwatch_event_rule" "application_events" {
  name           = "${local.service_prefix}-events-rule"
  description    = "EventBridge rule for Application Service events"
  event_bus_name = var.event_bus_name
  event_pattern  = var.event_pattern
  state          = "ENABLED"

  tags = merge(var.tags, {
    Service     = var.name
    Environment = var.environment
  })
}

resource "aws_cloudwatch_event_target" "application_target" {
  rule           = aws_cloudwatch_event_rule.application_events.name
  event_bus_name = var.event_bus_name
  arn            = module.lambda_unique.lambda_arn
  target_id      = "${local.service_prefix}-unique-target"

  # ... (rest of the resource configuration)
}