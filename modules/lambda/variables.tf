variable "function_name" {
  description = "Your Lambda Function unique name."
  type        = string
  default     = ""
}

variable "description" {
  description = "Your Lambda Function description."
  type        = string
  default     = ""
}

variable "handler" {
  description = "Lambda function code entrypoint."
  type        = string
  default     = ""
}

variable "runtime" {
  description = "Lambda function runtime."
  type        = string
  default     = ""
}

variable "lambda_role" {
  description = "Lambda function iam role arn."
  type        = string
  default     = ""
}

variable "source_path" {
  description = "Lambda function source code path"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Lambda function environment variables."
  type        = map(string)
  default     = {}
}

variable "ephemeral_storage_size" {
  description = "Lambda function temporary storage in mb."
  type        = number
  default     = 512
  validation {
    condition = var.ephemeral_storage_size >= 512 && var.ephemeral_storage_size <= 10240
    error_message = "The ephemeral storage size must be between 512 mb and 10 gb."
  }
}

variable "tracing_config" {
  description = "Lambda function tracing config."
  type = map(string)
  default = {}
}

variable "tags" {
  description = "Lambda function tags."
  type        = map(string)
  default     = {}
}


