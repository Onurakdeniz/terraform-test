data "aws_bedrock_foundation_model" "example" {
  model_id = "amazon.titan-text-express-v1"
}


resource "aws_bedrock_custom_model" "example" {
  custom_model_name     = "example-model"
  job_name              = "example-job-1"
  base_model_identifier = data.aws_bedrock_foundation_model.example.model_arn
  role_arn              = aws_iam_role.example.arn

  hyperparameters = {
    epochCount              = "1"
    batchSize               = "1"
    learningRate            = "0.005"
    learningRateWarmupSteps = "0"
  }

  output_data_config {
    s3_uri = "s3://${var.output_bucket}/data/"
  }

  training_data_config {
    s3_uri = "s3://${var.training_bucket}/data/train.jsonl"
  }
}





// Declare the IAM role
resource "aws_iam_role" "example" {
  name = "example-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "bedrock.amazonaws.com",
        },
      },
    ],
  })
}

// Declare the S3 buckets
resource "aws_s3_bucket" "output" {
  bucket = var.output_bucket

  tags = {
    Environment = "dev"
    Project     = "YourProjectName"
  }
}

resource "aws_s3_bucket" "training" {
  bucket = var.training_bucket

  tags = {
    Environment = "dev"
    Project     = "YourProjectName"
  }
}

resource "aws_iam_role" "bedrock_role" {
  name = "bedrock-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "bedrock.amazonaws.com",
        },
      },
    ],
  })

  tags = {
    Environment = "dev"
    Project     = "YourProjectName"
  }
}