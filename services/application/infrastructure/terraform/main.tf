provider "aws" {
  region = var.aws_region
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../src"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "get_applications" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "get-applications"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.getApplications"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
}

resource "aws_lambda_function" "create_application" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "create-application"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.createApplication"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
}

resource "aws_lambda_function" "get_application" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "get-application"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.getApplication"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
}

resource "aws_lambda_function" "update_application" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "update-application"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.updateApplication"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
}

resource "aws_lambda_function" "delete_application" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "delete-application"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.deleteApplication"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
}

resource "aws_iam_role" "lambda_role" {
  name = "application_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}