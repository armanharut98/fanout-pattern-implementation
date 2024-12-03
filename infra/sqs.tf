resource "aws_sqs_queue" "marketing" {
  name                       = "MarketingQueue"
  max_message_size           = 2048
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 3
  visibility_timeout_seconds = 10
}

resource "aws_sqs_queue" "analytics" {
  name                       = "AnalyticsQueue"
  max_message_size           = 2048
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 3
  visibility_timeout_seconds = 10
}

resource "aws_sqs_queue" "inventory" {
  name                       = "InventoryQueue"
  max_message_size           = 2048
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 3
  visibility_timeout_seconds = 10
}
