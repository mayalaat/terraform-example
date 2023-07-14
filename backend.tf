terraform {
  backend "s3" {
    bucket         = "solmedia-tf-states"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "solmedia-tf-states"
  }
}
