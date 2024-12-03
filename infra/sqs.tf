resource "aws_sqs_queue" "lambda" {
  for_each                   = toset(local.lambda_services)
  name                       = "${each.key}_queue"
  max_message_size           = 2048
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 3
  visibility_timeout_seconds = 10
}

data "aws_iam_policy_document" "lambda" {
  for_each = toset(local.lambda_services)
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.lambda[each.key].arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.new_product.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "lambda" {
  for_each  = toset(local.lambda_services)
  queue_url = aws_sqs_queue.lambda[each.key].url
  policy    = data.aws_iam_policy_document.lambda[each.key].json
}
