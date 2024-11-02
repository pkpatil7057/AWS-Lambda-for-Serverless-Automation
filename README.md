# AWS Lambda Serverless Automation

This project demonstrates setting up a serverless automation using AWS Lambda, S3, and SNS. When a new file is uploaded to an S3 bucket, a Lambda function triggers and sends a notification through SNS.

## Requirements

- AWS Account
- Terraform installed
- IAM permissions for creating S3, Lambda, and SNS resources

## Project Structure

- `lambda_function.py`: Python code for the Lambda function.
- `main.tf`: Terraform configuration file.
- `variables.tf`: Terraform variables file.
- `outputs.tf`: Terraform outputs for easy reference.

## Setup Instructions

1. Zip the Lambda function file (`lambda_function.py`) before deploying.
   ```bash
   zip lambda_function.zip lambda_function.py

