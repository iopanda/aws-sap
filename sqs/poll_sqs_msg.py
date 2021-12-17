import boto3

QUEUE_URL = "https://sqs.ap-northeast-1.amazonaws.com/179965235900/testsqs"

def get_msg_from_sqs():
    sqs_client = boto3.client('sqs')

    print("--- Getting message from SQS")
    response = sqs_client.receive_message(
        QueueUrl=QUEUE_URL,
        MaxNumberOfMessages=10,
        WaitTimeSeconds=10
    )

    messages = response.get('Messages')

    if messages:
        for message in messages:
            msg_id = message.get('MessageId')
            msg_body = message.get('Body')
            receipt_handle = message.get('ReceiptHandle')

            print(f"Processing SQS message {msg_id} which msg is {msg_body}...")

            print(f"Deleting SQS message {msg_id}...")
            sqs_client.delete_message(QueueUrl=QUEUE_URL,
                                      ReceiptHandle=receipt_handle)

            print(f"SQS message {msg_id} deleted")
    else:
        print("No message in the queue")
        return


if __name__ == '__main__':
    get_msg_from_sqs()
