module "opensearch" {
  source             = "../../modules/opensearch"
  domain_name        = "es-local"
  engine_version     = "OpenSearch_2.11"
  instance_count     = 1
  availability_zones = 1
  ebs_options = {
    enabled = true
  }
  depends_on = [aws_cloudwatch_log_stream.example]
}

module "lambda" {
  source        = "../../modules/lambda"
  function_name = "transformer"
  description   = "lambda function for log transformation"
  lambda_role   = aws_iam_role.lambda_role.arn
  source_path   = "index.py"
  handler       = "index.handler"
  runtime       = "python3.7"
}

module "firehose" {
  source      = "../../modules/firehose"
  name        = "opensearch-streaming"
  destination = "opensearch"

  opensearch_domain_arn  = module.opensearch.domain_arn
  firehose_role_arn      = "arn:aws:iam::000000000000:role/Firehose-Reader-Role"
  opensearch_index_name  = "activity"
  opensearch_type_name   = "activity"
  enable_processing      = true
  processing_lambda_arn  = "arn:aws:lambda:us-east-1:000000000000:function:transformer"
  processing_lambda_role = "arn:aws:iam::000000000000:role/LambdaRole"
  s3_backup_bucket_arn   = aws_s3_bucket.backup.arn
  s3_backup_mode         = "AllDocuments"
}

resource "aws_s3_bucket" "backup" {
  bucket = "kinesis-activity-backup-local"
  depends_on = [module.opensearch]
}

resource "aws_cloudwatch_log_group" "example" {
  name = "localstack-log-group"
}

resource "aws_cloudwatch_log_stream" "example" {
  log_group_name = aws_cloudwatch_log_group.example.name
  name           = "local-instance"
  depends_on = [aws_cloudwatch_log_group.example]
}

resource "aws_cloudwatch_log_subscription_filter" "example" {
  log_group_name  = aws_cloudwatch_log_group.example.name
  name            = "kinesis-test"
  filter_pattern  = ""
  destination_arn = module.firehose.stream_arn
  role_arn        = "arn:aws:iam::000000000000:role/kinesis_role"
  depends_on = [module.firehose]
}