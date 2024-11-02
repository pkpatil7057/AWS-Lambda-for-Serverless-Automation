provider "aws" {
  region = "us-west-2"  # Specify your AWS region
}

# Create S3 bucket
resource "aws_s3_bucket" "lambda_trigger_bucket" {
  bucket = "lambda-trigger-s3-bucket"
}

# Create SNS topic for notifications
resource "aws_sns_topic" "sns_topic" {
  name = "s3-upload-notification"
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach policy to Lambda IAM role
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:*",
          "s3:GetObject",
          "sns:Publish"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Create Lambda function
resource "aws_lambda_function" "s3_upload_notifier" {
  function_name = "S3UploadNotifier"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_role.arn
  filename      = "lambda_function.zip"  # Assume we package this separately

  # Environment variables for SNS
  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.sns_topic.arn
    }
  }
}

# Add trigger for S3 bucket to invoke Lambda
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.lambda_trigger_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_upload_notifier.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

