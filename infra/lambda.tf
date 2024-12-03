data "aws_s3_object" "lambda" {
  for_each = toset(local.lambda_services)
  bucket   = local.bucket_name
  key      = "lambdas/${each.key}-lambda.zip"
}

resource "aws_iam_role" "lambda_exec" {
  for_each = toset(local.lambda_services)
  name     = "${each.key}_lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda" {
  for_each   = toset(local.lambda_services)
  role       = aws_iam_role.lambda_exec[each.key].name
  policy_arn = aws_iam_policy.lambda[each.key].arn
}

resource "aws_iam_policy" "lambda" {
  for_each = toset(local.lambda_services)
  name     = "${each.key}_lambda_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
        ],
        Effect   = "Allow",
        Resource = aws_sqs_queue.lambda[each.key].arn
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "lambda" {
  for_each         = toset(local.lambda_services)
  function_name    = "${each.key}_lambda"
  s3_bucket        = local.bucket_name
  s3_key           = data.aws_s3_object.lambda[each.key].key
  role             = aws_iam_role.lambda_exec[each.key].arn
  runtime          = "nodejs16.x"
  handler          = "index.handler"
  source_code_hash = data.aws_s3_object.lambda[each.key].etag
}

resource "aws_lambda_event_source_mapping" "lambda" {
  for_each         = toset(local.lambda_services)
  event_source_arn = aws_sqs_queue.lambda[each.key].arn
  function_name    = aws_lambda_function.lambda[each.key].arn
}
