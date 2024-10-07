resource "aws_iam_role" "terraform_state_role" {
  description        = "Terraform state file role for accessing s3 and dynamodb"
  name               = "StateRole"
  assume_role_policy = data.aws_iam_policy_document.terraform_state_policy.json
}

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