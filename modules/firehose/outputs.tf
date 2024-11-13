output "stream_arn" {
  description = "Kinesis firehose stream arn."
  value       = aws_kinesis_firehose_delivery_stream.main.arn
}