data "aws_s3_object" "lambda" {
  for_each = toset(local.lambda_services)
  bucket   = local.bucket_name
  key      = "lambdas/${each.key}-lambda-source.zip"
}

resource "aws_security_group" "lambda-sg" {
  name = "lambda-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-sg"
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

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

resource "aws_iam_role_policy_attachment" "name" {
  role       = aws_iam_role.lambda_exec.arn
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda" {
  for_each         = toset(local.lambda_services)
  function_name    = "${each.key}-lambda"
  s3_bucket        = local.bucket_name
  s3_key           = aws_s3_object.lambda[each.key].key
  role             = aws_iam_role.lambda_exec.arn
  runtime          = ["nodejs16.x"]
  handler          = "index.handler"
  source_code_hash = data.aws_s3_object.lambda.etag
}
