variable "name" {
  description = "Kinesis firehose stream unique name"
  type        = string
}

variable "destination" {
  description = "Destination to where the data is delivered."
  type        = string
  validation {
    condition = contains([
      "s3", "extended_s3", "redshift", "opensearch",
      "opensearchserverless", "elasticsearch",
    ], var.destination)
    error_message = "Please use a valid destination!"
  }
}

variable "firehose_role_arn" {
  description = "Kinesis firehose role arn."
  type        = string
  default     = null
}

variable "input_source" {
  description = "Kinesis firehose source."
  type        = string
  default     = "direct-put"
  validation {
    condition = contains(["direct-put", "kinesis", "waf", "msk"], var.input_source)
    error_message = "Please use a valid source!"
  }
}

/* opensearch configuration variables */

variable "opensearch_domain_arn" {
  description = "OpenSearch domain arn."
  type        = string
  default     = null
}

variable "opensearch_index_name" {
  description = "OpenSearch index name."
  type        = string
  default     = null
}

variable "opensearch_type_name" {
  description = "OpenSearch index type of documents."
  type        = string
  default     = null
}

variable "s3_backup_mode" {
  description = "Specifies how documents are backed up to S3."
  type        = string
  default     = "All"
  validation {
    condition = contains(["FailedDocumentsOnly", "AllDocuments"], var.s3_backup_mode)
    error_message = "Valid values are FailedOnly and All."
  }
}

variable "s3_backup_bucket_arn" {
  description = "Specifies s3 bucket arn to where documents are backed up."
  type        = string
  default     = null
}

variable "enable_processing" {
  description = "Whether to enable data transformation using lambda."
  type        = bool
  default     = false
}

variable "processing_lambda_arn" {
  description = "Processing lambda function arn."
  type        = string
  default     = null
}

variable "processing_lambda_role" {
  description = "Processing lambda function role."
  type        = string
  default     = null
}

variable "tags" {
  description = "Firehose module tags."
  type        = map(string)
  default     = {}
}
