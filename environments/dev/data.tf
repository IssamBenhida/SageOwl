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
    "es:*"
    ]
    resources = [module.opensearch.domain_arn]
  }
}
