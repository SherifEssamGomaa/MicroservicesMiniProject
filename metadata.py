import boto3
import csv
sqsC = boto3.client('sqs')
queue_url = sqsC.get_queue_url(QueueName='second_queue')['QueueUrl']
messages = sqsC.receive_message(QueueUrl=queue_url, MaxNumberOfMessages=10) 
while True:
    response = sqsC.receive_message(QueueUrl=queue_url, MaxNumberOfMessages=1)
    messages = response.get('Messages', [])
    if not messages:
        continue
    message = messages[0]
    receipt_handle = message['ReceiptHandle']
    with open('message_data.csv', 'w', newline='') as csvfile: 
        csvwriter = csv.writer(csvfile) 
        csvwriter.writerow(['MessageId', 'ReceiptHandle', 'Body']) 
        for message in messages['Messages']:
            message_id = message['MessageId']
            receipt_handle = message['ReceiptHandle']
            body = message['Body']
            csvwriter.writerow([message_id, receipt_handle, body])