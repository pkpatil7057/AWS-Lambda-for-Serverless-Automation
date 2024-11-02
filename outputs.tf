output "sns_topic_arn" {
  value = aws_sns_topic.sns_topic.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.lambda_trigger_bucket.id
}

output "lambda_function_name" {
  value = aws_lambda_function.s3_upload_notifier.function_name
}

