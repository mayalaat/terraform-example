resource "aws_lambda_function" "catalog-writer" {
  function_name = "catalog-writer"
  role          = aws_iam_role.iam_for_lambda.arn
  filename      = "catalog-writer.zip"
  handler       = "code.lambda_handler"

  source_code_hash = filebase64sha256("catalog-writer.zip")

  runtime = "python3.9"
}

// policy for catalog-writer lambda write in dynamodb
data "aws_iam_policy_document" "inline-policy" {
  statement {
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:ListTables",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:UpdateTable",
    ]

    resources = [aws_dynamodb_table.apps_store.arn]

    effect = "Allow"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "lambda-role"

  inline_policy {
    name   = "policy-dynamodb-writer"
    policy = data.aws_iam_policy_document.inline-policy.json
  }

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

//permission for send an event to catalog-writer lambda
resource "aws_lambda_permission" "allow_bucket" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.catalog-writer.arn
  principal     = "s3.amazonaws.com"
  statement_id  = "AllowExecutionFromS3Bucket"
  source_arn    = aws_s3_bucket.bucket.arn
}
