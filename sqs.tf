resource "aws_sqs_queue" "first_queue" {
  name = "first_queue"
  visibility_timeout_seconds = 60
}

resource "aws_sqs_queue_policy" "first_queue_policy" {
  queue_url = aws_sqs_queue.first_queue.id
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "sqspolicy",
    "Statement": [
        {
        "Sid": "First",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "sqs:SendMessage",
        "Resource": "${aws_sqs_queue.first_queue.arn}",
        "Condition": {"ArnEquals": {"aws:SourceArn": "${aws_sns_topic.s3_event_notification_topic.arn}"}}
        }
    ]
  }
  POLICY
}

resource "aws_sns_topic_subscription" "first_queue_topic_subscription" {
  topic_arn = aws_sns_topic.s3_event_notification_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.first_queue.arn
}

resource "aws_sqs_queue" "second_queue" {
  name = "second_queue"
  visibility_timeout_seconds = 60
}

resource "aws_sqs_queue_policy" "second_queue_policy" {
  queue_url = aws_sqs_queue.second_queue.id
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "sqspolicy",
    "Statement": [
        {
        "Sid": "First",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "sqs:SendMessage",
        "Resource": "${aws_sqs_queue.second_queue.arn}",
        "Condition": {"ArnEquals": {"aws:SourceArn": "${aws_sns_topic.s3_event_notification_topic.arn}"}}
        }
    ]
  }
  POLICY
}

resource "aws_sns_topic_subscription" "second_queue_topic_subscription" {
  topic_arn = aws_sns_topic.s3_event_notification_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.second_queue.arn
}

