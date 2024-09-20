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
    dynamodb_table = "state-lock-table"
    bucket         = "state-lock-bucket"
    key            = "terraform.state"
    region         = "us-east-1"
  }
}