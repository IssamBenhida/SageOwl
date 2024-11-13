output "lambda_name" {
  description = "Lambda function name."
  value = aws_lambda_function.main.function_name
}

output "lambda_arn" {
  description = "Lambda function arn."
  value       = aws_lambda_function.main.arn
}

output "lambda_invoke_arn" {
  description = "Lambda function invoke arn."
  value = aws_lambda_function.main.invoke_arn
}

output "lambda_environment" {
  description = "Lambda function environment variables."
  value = aws_lambda_function.main.environment
}

output "lambda_runtime" {
  description = "Lambda function runtime."
  value = aws_lambda_function.main.runtime
}

output "lambda_role" {
  description = "Lambda function role."
  value = aws_lambda_function.main.role
}

output "lambda_last_modified" {
  description = "Lambda function last modified date."
  value = aws_lambda_function.main.last_modified
}

output "lambda_source_code_hash" {
  description = "Lambda function source code hash ."
  value = aws_lambda_function.main.source_code_hash
}

output "lambda_timeout" {
  description = "Lambda function timeout settings."
  value = aws_lambda_function.main.timeout
}

output "lambda_memory_size" {
  description = "Lambda function memory size."
  value = aws_lambda_function.main.memory_size
}
