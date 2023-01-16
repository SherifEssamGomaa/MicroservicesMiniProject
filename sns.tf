resource "aws_sns_topic" "s3_event_notification_topic" {
  name = "s3_event_notification_topic"
  policy = <<POLICY
  {
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:s3-event-notification-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.sherif_essam_upload_bucket.arn}"}
        }
    }]
  }          
  POLICY
}


resource "aws_sns_topic_subscription" "topic_subscription_email" {
  topic_arn = aws_sns_topic.s3_event_notification_topic.arn
  protocol  = "email"
  endpoint  = "sherifessamahmed@gmail.com"
}