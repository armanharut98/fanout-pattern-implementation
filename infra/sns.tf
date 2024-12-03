resource "aws_sns_topic" "new_product" {
  name = "NewProductTopic"
}

resource "aws_sns_topic_subscription" "marketing" {
  for_each  = toset(local.lambda_services)
  topic_arn = aws_sns_topic.new_product.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.lambda[each.key].arn
}
