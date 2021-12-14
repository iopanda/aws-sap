import boto3
import logging

logging.getLogger().setLevel(logging.INFO)

def lambda_handler(event, _):
    ec2_client = boto3.client('ec2')
    instances_in_scope = _get_ec2_instances_to_stop(ec2_client)
    logging.info(f"Stopping ec2 instances following {instances_in_scope}")
    ec2_client.stop_instances(InstanceIds=instances_in_scope)
    logging.info(f"All the ec2 instances in scope have been stopped")

def _get_ec2_instances_to_stop(ec2_client):
    response = ec2_client.describe_instances(
        Filters=[
            {
                "Name": "instance-state-name",
                "Values": ["running"]
            }
        ]
    )

    instances_to_stop = []

    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            instances_to_stop.append(instance["InstanceId"])

    return instances_to_stop