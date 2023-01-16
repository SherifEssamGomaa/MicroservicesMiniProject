import boto3
import json
s3 = boto3.client('s3')
sqsC = boto3.client('sqs')
sqsR = boto3.resource('sqs')
queue = sqsR.get_queue_by_name(QueueName='first_queue')
queue_url = queue.url
while True:
    response = sqsC.receive_message(QueueUrl=queue_url, MaxNumberOfMessages=1)
    messages = response.get('Messages', [])
    if not messages:
        continue
    message = messages[0]
    body = json.loads(message['Body'])
    receipt_handle = message['ReceiptHandle']
    message_body = json.loads(body["Message"])
    record = message_body["Records"][0]
    bucket_name = record["s3"]["bucket"]["name"]
    file_name = record["s3"]["object"]["key"]
    s3.download_file(bucket_name, file_name, f'D:\MicroservicesMiniProject\{file_name}')
    sqsC.delete_message(QueueUrl=queue_url, ReceiptHandle=receipt_handle)
    with open(f'{file_name}', 'r') as f:
        data = f.read()
        data = data.replace(',', '\n')
    with open(f'{file_name}', 'w') as f:
        f.write(data)
    s3.upload_file(file_name, 'sherif_essam_backup_bucket', file_name)