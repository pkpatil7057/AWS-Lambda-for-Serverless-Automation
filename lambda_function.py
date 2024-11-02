import json
import boto3
import os

sns_client = boto3.client('sns')
sns_topic_arn = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    # Extract bucket name and file key from the event
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        file_key = record['s3']['object']['key']
        
        # Message for SNS notification
        message = f"A new file '{file_key}' was uploaded to bucket '{bucket_name}'."
        
        # Publish to SNS topic
        sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=message,
            Subject="New S3 File Upload Notification"
        )
        
    return {
        'statusCode': 200,
        'body': json.dumps('Notification sent successfully!')
    }

