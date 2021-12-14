import boto3
import json
import gzip
import ast

def lambda_handler(event, _):
    msg = json.loads(event["Records"][0]["Sns"]["Message"])

    s3 = boto3.resource('s3')
    if "ap-northeast-1" in msg["s3ObjectKey"][0]:
        object = s3.Object(msg["s3Bucket"], msg["s3ObjectKey"][0])

        with gzip.GzipFile(fileobj=object.get()['Body']) as gzipfile:
            content = gzipfile.read()

        trail_dict = json.loads(content.decode('UTF-8'))
        for trail in trail_dict["Records"]:
            print(f"{trail['eventName']} event detected")
            if trail["eventName"] == "CreateVpc":
                print("Detected the a VPC has been created which should not be allowed")
                print(f'S3 object key: {msg["s3ObjectKey"][0]}')
                vpc_id = trail["responseElements"]["vpc"]["vpcId"]
                print(f"Will delete vpc {vpc_id}")
                client = boto3.client('ec2')
                response = client.delete_vpc(
                    VpcId=vpc_id,
                )

                print(f"The vpc {vpc_id} has been deleted.")
            else:
                print("Checking next trail")


