module "lambda" {
  source        = "../../modules/lambda"
  function_name = "transformer"
  description   = "lambda function for log transformation"
  lambda_role   = aws_iam_role.lambda_to_firehose_role.arn
  source_path   = "../../lambda/index.py"
  handler       = "index.handler"
  runtime       = "python3.7"

  tracing_config = {
    mode = "PassThrough"
  }

  environment_variables = {
    geo_api_url = "https://ipinfo.io/"
  }

  tags = {
    department  = "security"
    function    = "processing"
    environment = "dev"
  }
}

module "opensearch" {
  source             = "../../modules/opensearch"
  domain_name        = "sageowl-local"
  engine_version     = "OpenSearch_2.11"
  instance_count     = 1
  availability_zones = 1

  ebs_options = {
    enabled     = true
    volume_type = "gp3"
    volume_size = "10"
  }

  timeouts = {
    create = "3m"
  }

  tags = {
    department  = "security"
    function    = "analytics"
    environment = "dev"
  }

  depends_on = [aws_cloudwatch_log_stream.main]
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

  tags = {
    department  = "security"
    function    = "streaming"
    environment = "dev"
  }
}


resource "aws_cloudwatch_log_group" "main" {
  name              = "sageowl"
  retention_in_days = 0
  log_group_class   = "INFREQUENT_ACCESS"

  kms_key_id = aws_kms_key.main.id

  tags = {
    department  = "security"
    function    = "logging"
    environment = "dev"
  }
}

resource "aws_cloudwatch_log_stream" "main" {
  log_group_name = aws_cloudwatch_log_group.main.name
  name           = "on-prime"

  depends_on = [aws_cloudwatch_log_group.main]
}

resource "aws_cloudwatch_log_subscription_filter" "main" {
  name            = "firehose"
  filter_pattern  = ""
  log_group_name  = aws_cloudwatch_log_group.main.name
  role_arn        = aws_iam_role.cloudwatch_to_firehose_role.arn
  destination_arn = module.firehose.stream_arn

  depends_on = [module.firehose]
}
