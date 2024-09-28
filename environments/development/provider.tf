terraform {
  required_providers {
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = "2.3.1"
    }
  }
}

provider "opensearch" {
  url = "http://es-local.us-east-1.opensearch.localhost.localstack.cloud:4566"
}

