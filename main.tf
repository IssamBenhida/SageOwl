terraform {
  backend "s3" {
    dynamodb_table = "state-lock-table"
    bucket         = "state-lock-bucket"
    key            = "terraform.state"
    region         = "us-east-1"
  }
}

data "archive_file" "lambda" {
  source_file = "index.py"
  output_path = "index.zip"
  type        = "zip"
}

data "aws_iam_policy_document" "lambda_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    resources = [aws_kinesis_firehose_delivery_stream.example.arn]
  }
  depends_on = [aws_kinesis_firehose_delivery_stream.example]
}

resource "aws_iam_role" "lambda_role" {
  assume_role_policy = data.aws_iam_policy_document.lambda_policy.json
  depends_on = [aws_kinesis_firehose_delivery_stream.example]
}

resource "aws_lambda_function" "processor" {
  function_name = "transformer"
  filename      = "index.zip"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.7"
  depends_on = [aws_kinesis_firehose_delivery_stream.example]
}


resource "aws_cloudwatch_log_group" "example" {
  name = "localstack-log-group"
}

resource "aws_cloudwatch_log_stream" "example" {
  log_group_name = aws_cloudwatch_log_group.example.name
  name           = "local-instance"
  depends_on = [aws_cloudwatch_log_group.example]
}

resource "aws_elasticsearch_domain" "es_local" {
  domain_name           = "es-local"
  elasticsearch_version = "7.10"
  depends_on = [aws_cloudwatch_log_stream.example]
}

resource "aws_s3_bucket" "backup" {
  bucket = "kinesis-activity-backup-local"
  depends_on = [aws_elasticsearch_domain.es_local]
}

resource "aws_kinesis_firehose_delivery_stream" "example" {
  name        = "activity-to-elasticsearch-local"
  destination = "elasticsearch"

  elasticsearch_configuration {
    role_arn       = "arn:aws:iam::000000000000:role/Firehose-Reader-Role"
    domain_arn     = aws_elasticsearch_domain.es_local.arn
    index_name     = "activity"
    type_name      = "activity"
    s3_backup_mode = "AllDocuments"

    s3_configuration {
      role_arn   = "arn:aws:iam::000000000000:role/Firehose-Reader-Role"
      bucket_arn = "arn:aws:s3:::kinesis-activity-backup-local"
    }

    processing_configuration {
      enabled = true
      processors {
        type = "Lambda"
        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "arn:aws:lambda:us-east-1:000000000000:function:transformer"
        }
        parameters {
          parameter_name  = "RoleArn"
          parameter_value = "arn:aws:iam::000000000000:role/LambdaRole"
        }
      }
    }
  }
  depends_on = [aws_s3_bucket.backup]
}
resource "aws_cloudwatch_log_subscription_filter" "example" {
  log_group_name  = aws_cloudwatch_log_group.example.name
  name            = "kinesis_test"
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.example.arn
  role_arn        = "arn:aws:iam::000000000000:role/kinesis_role"

  depends_on = [aws_kinesis_firehose_delivery_stream.example]
}

output "DeliveryStreamARN" {
  value = aws_kinesis_firehose_delivery_stream.example.arn
}
