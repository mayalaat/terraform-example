terraform {
  backend "s3" {
    bucket         = "solmedia-tf-states"
    key            = "dev/services/catalog/storage/dynamodb/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "solmedia-tf-states"
  }
}
