resource "aws_s3_bucket" "sherif_essam_upload_bucket" {
  bucket = "sherif-essam-upload-bucket"
  tags = {
    Name = "sherif-essam-upload-bucket"
  }
}

resource "aws_s3_bucket" "sherif_essam_backup_bucket" {
  bucket = "sherif-essam-backup-bucket"
  tags = {
    Name = "sherif-essam-backup-bucket"
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.sherif_essam_upload_bucket.id
  topic {
    topic_arn     = aws_sns_topic.s3_event_notification_topic.arn
    events        = ["s3:ObjectCreated:*"]
  }
}