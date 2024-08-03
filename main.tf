terraform {
  backend "s3" {
    dynamodb_table = "state-lock-table"
    bucket         = "state-lock-bucket"
    key            = "terraform.state"
    region         = "us-east-1"
  }
}

resource "aws_elasticsearch_domain" "es-local" {
  domain_name           = "es-local"
  elasticsearch_version = "7.10"
}

resource "aws_s3_bucket" "backup" {
  bucket = "kinesis-activity-backup-local"
}


resource "aws_kinesis_stream" "test_stream" {
  name        = "kinesis-es-local-stream"
  shard_count = 2
}

resource "aws_kinesis_firehose_delivery_stream" "example" {
  name        = "activity-to-elasticsearch-local"
  destination = "elasticsearch"


  kinesis_source_configuration {
    kinesis_stream_arn = "arn:aws:kinesis:us-east-1:000000000000:stream/kinesis-es-local-stream"
    role_arn           = "arn:aws:iam::000000000000:role/Firehose-Reader-Role"
  }

  elasticsearch_configuration {
    role_arn       = "arn:aws:iam::000000000000:role/Firehose-Reader-Role"
    domain_arn     = "arn:aws:es:us-east-1:000000000000:domain/es-local"
    index_name     = "activity"
    type_name      = "activity"
    s3_backup_mode = "AllDocuments"

    s3_configuration {
      role_arn   = "arn:aws:iam::000000000000:role/Firehose-Reader-Role"
      bucket_arn = "arn:aws:s3:::kinesis-activity-backup-local"
    }
  }

  depends_on = [aws_elasticsearch_domain.es-local, aws_kinesis_stream.test_stream, aws_s3_bucket.backup]
}

output "DeliveryStreamARN" {
  value = aws_kinesis_firehose_delivery_stream.example.arn
}