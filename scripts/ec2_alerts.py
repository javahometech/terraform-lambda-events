import boto3
import os

snsClient = boto3.client('sns')
topicARN = os.environ['TOPIC_ARN']
def send_alerts(event, context):
    instance_id = event['detail']['instance-id']
    snsClient.publish(
            TopicArn = topicARN,
            Message = f"Alert - Instance with Id {instance_id} stopping",
            Subject = "EC2 Alerts - JavaHome"
        )
