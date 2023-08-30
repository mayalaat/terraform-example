resource "aws_lambda_function" "catalog-writer" {
  function_name = "catalog-writer"
  role          = aws_iam_role.iam_for_lambda.arn
  filename      = "catalog-writer.zip"
  handler       = "code.lambda_handler"

  source_code_hash = filebase64sha256("catalog-writer.zip")

  runtime = "python3.9"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
