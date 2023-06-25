output "checkout_url" {
  description = "URL of the first SQS queue"
  value = aws_sqs_queue.checkout.id
}

output "orderPlaced_url" {
  description = "URL of the second SQS queue"
  value = aws_sqs_queue.orderPlaced.id
}
