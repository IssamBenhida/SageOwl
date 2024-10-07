resource "aws_iam_role" "terraform_state_role" {
  description        = "Terraform state file role for accessing s3 and dynamodb"
  name               = "StateRole"
  assume_role_policy = data.aws_iam_policy_document.terraform_state_policy.json
}

resource "aws_iam_role" "cloudwatch_to_firehose_role" {
  description        = "CloudWatch role for accessing firehose"
  name               = "CloudWatchToFirehoseRole"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_to_firehose_policy.json
}

resource "aws_iam_role" "firehose_role" {
  description        = "firehose role for accessing lambda, s3 and opensearch."
  name               = "FirehoseRole"
  assume_role_policy = data.aws_iam_policy_document.firehose_policy.json
}

resource "aws_iam_role" "lambda_to_firehose_role" {
  description        = "lambda role for accessing firehose."
  name               = "LambdaToFirehoseRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_to_firehose_policy.json
}