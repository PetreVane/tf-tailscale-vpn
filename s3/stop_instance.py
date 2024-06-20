

import boto3
import os
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def lambda_handler(event, context):
    aws_region  = os.getenv('AWS_REGION')
    instance_id = os.getenv('INSTANCE_ID')

    ec2 = boto3.client('ec2', region_name=aws_region)

    try:
        ec2.stop_instances(InstanceIds=[instance_id])
        logger.info(f"Started instance: {instance_id}")
    except Exception as e:
        logger.error(f"Error starting instance {instance_id}: {str(e)}")
        raise e

