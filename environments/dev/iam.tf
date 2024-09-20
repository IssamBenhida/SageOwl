resource "aws_iam_role" "lambda_role" {
  description        = "Lambda role for accessing firehose."
  name               = "LambdaRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role" "firehose_role" {
  description        = "Firehose role for accessing opensearch."
  name               = "FirehoseRole"
  assume_role_policy = data.aws_iam_policy_document.firehose_policy.json
}