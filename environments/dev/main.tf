module "opensearch" {
  source             = "../../modules/opensearch"
  domain_name        = "es-local"
  engine_version     = "OpenSearch_2.11"
  instance_count     = 1
  availability_zones = 1

  ebs_options = {
    enabled = true
  }

  depends_on = [aws_cloudwatch_log_stream.main]
}

module "lambda" {
  source        = "../../modules/lambda"
  function_name = "transformer"
  description   = "lambda function for log transformation"
  lambda_role   = aws_iam_role.lambda_to_firehose_role.arn
  source_path   = "../../lambda/index.py"
  handler       = "index.handler"
  runtime       = "python3.7"
}

module "firehose" {
  source      = "../../modules/firehose"
  name        = "bullet"
  destination = "opensearch"

  opensearch_domain_arn  = module.opensearch.domain_arn
  firehose_role_arn      = aws_iam_role.firehose_role.arn
  opensearch_index_name  = "sageowl"
  opensearch_type_name   = "_doc"
  enable_processing      = true
  processing_lambda_arn  = module.lambda.lambda_arn
  processing_lambda_role = aws_iam_role.lambda_to_firehose_role.arn
  s3_backup_bucket_arn   = aws_s3_bucket.backup.arn
  s3_backup_mode         = "AllDocuments"
}

resource "aws_s3_bucket" "backup" {
  bucket     = "kinesis-activity-backup-local"
  depends_on = [module.opensearch]
}

resource "aws_cloudwatch_log_group" "main" {
  name = "sageowl"
}

resource "aws_cloudwatch_log_stream" "main" {
  log_group_name = aws_cloudwatch_log_group.main.name
  name           = "development"
  depends_on     = [aws_cloudwatch_log_group.main]
}

resource "aws_cloudwatch_log_subscription_filter" "main" {
  name            = "firehose"
  filter_pattern  = ""
  log_group_name  = aws_cloudwatch_log_group.main.name
  role_arn        = aws_iam_role.cloudwatch_to_firehose_role.arn
  destination_arn = module.firehose.stream_arn
  depends_on      = [module.firehose]
}