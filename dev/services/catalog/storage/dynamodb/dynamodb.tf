resource "aws_dynamodb_table" "apps_store" {
  name           = "${var.env}-${var.dynamodb_name}"
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "ImageId"
  range_key      = "LastUpdatedTime"

  attribute {
    name = "ImageId"
    type = "S"
  }

  attribute {
    name = "LastUpdatedTime"
    type = "S"
  }

  tags = {
    Environment = var.env
    Project     = "Terraform course"
  }
}
