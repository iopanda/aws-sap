import boto3
import json

QUEUE_URL = "https://sqs.ap-northeast-1.amazonaws.com/179965235900/testsqs"


def _online_shopping():
    good = input("What do you want to buy? ")
    amount = input("How many do you want to buy? ")

    confirm_order = _yes_or_no("Do you want to submmit your order now?")

    if confirm_order:
        _push_msg_to_sqs({good:amount})


def _yes_or_no(question):
    reply = str(input(question+' (y/n): ')).lower().strip()
    if reply[0] == 'y':
        return True
    if reply[0] == 'n':
        return False
    else:
        return _yes_or_no("Uhhhh... please enter ")


def _push_msg_to_sqs(message):
    sqs_client = boto3.client('sqs')

    response = sqs_client.send_message(
        QueueUrl=QUEUE_URL,
        MessageBody=json.dumps(message)
    )

    if response["ResponseMetadata"]["HTTPStatusCode"] == 200:
        print("Thanks, your order has been submitted.")
        return

    print("Ops... something is wrong when pushing msg to sqs")


if __name__ == '__main__':
    _online_shopping()
