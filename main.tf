resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = "Dev"
    Project = "Terraform course"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "hello"
  source = "hello.html"

  content_type = "text/html"
}
