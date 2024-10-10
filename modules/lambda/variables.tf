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

