terraform {
  backend "s3" {
    bucket = "avei-playground-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}