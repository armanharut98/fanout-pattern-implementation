resource "aws_sns_topic" "new_product" {
  name   = "NewProductTopic"
  policy = aws_iam_policy.sns_policy.arn
}

resource "aws_sns_topic_subscription" "marketing" {
  topic_arn = aws_sns_topic.new_product.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.marketing.arn
}

resource "aws_sns_topic_subscription" "inventory" {
  topic_arn = aws_sns_topic.new_product.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.inventory.arn
}

resource "aws_sns_topic_subscription" "analytics" {
  topic_arn = aws_sns_topic.new_product.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.analytics.arn
}

resource "aws_iam_policy" "sns_policy" {
  name        = "sqs-sendMessage-policy"
  description = "SNS Policy to send messages to the Amazon SQS queue"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sqs:SendMessage"
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
      },
    ]
  })
}
