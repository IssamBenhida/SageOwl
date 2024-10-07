data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "terraform_state_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:terraform-state-lock-bucket/development/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
      "dynamodb:DescribeTable"
    ]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/terraform-state-lock-table"
    ]
  }
}


data "aws_iam_policy_document" "lambda_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    resources = [module.firehose.stream_arn]
  }
}

data "aws_iam_policy_document" "firehose_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "es:ESHttpPut"
    ]
    resources = [module.opensearch.domain_arn]
  }
}
