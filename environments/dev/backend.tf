/*
 * Terraform State Configuration
 *
 * Components:
 * - S3 Bucket: for storing the Terraform state file securely.
 * - DynamoDB Table: Provides state locking mechanism to avoid conflicts.
 * - Encryption: Ensures the Terraform state is encrypted at rest in S3.
 * - IAM Role: Adhering to the principle of least privilege.
 *
 */

terraform {
  backend "s3" {
    dynamodb_table = "terraform-state-lock-table"
    bucket         = "terraform-state-lock-bucket"
    key            = "development/terraform.state"
    role_arn       = aws_iam_role.terraform_state_role.arn
    region         = data.aws_region.current.name
    encrypt        = true
  }
}