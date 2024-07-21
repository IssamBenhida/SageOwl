terraform {
  backend "s3" {
    dynamodb_table = "state-lock-table"
    bucket = "state-lock-bucket"
    key = "terraform.state"
    region = "us-east-1"

  }
}

resource "aws_s3_bucket" "test" {
  bucket = "my-first-bucket"
}