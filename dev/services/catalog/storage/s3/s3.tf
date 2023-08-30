locals {
  whitelist_cidr = ["0.0.0.0/0"]
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = "Dev"
    Project     = "Terraform course"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "hello"
  source = "hello.html"

  content_type = "text/html"
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.main.json

  depends_on = [aws_s3_bucket_public_access_block.block]
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "main" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
    condition {
      test     = "IpAddress"
      values   = local.whitelist_cidr
      variable = "aws:sourceIp"
    }
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
}

// get arn from lambda tfstate
data "terraform_remote_state" "remote_lambda" {
  backend = "s3"
  config  = {
    bucket = "solmedia-bucket"
  }
}

// send s3 notification to lambda
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    events              = ["s3:ObjectCreated:*"]
    lambda_function_arn = data.terraform_remote_state.remote_lambda.outputs.lambda_arn
    filter_suffix       = ".png"
  }
}
