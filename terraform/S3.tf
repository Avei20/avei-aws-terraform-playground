resource "aws_s3_bucket" "lambda_s3_bucket" {
  bucket = "avei-playground-bucket"
  acl =  "private"
  force_destroy = true
}

resource "aws_s3_bucket_object" "lambda_s3_bucket_object" {
  bucket = "avei-playground-bucket"
  key = "/"
  source = "lambda.zip"
  
  depends_on = [aws_s3_bucket.lambda_s3_bucket]
}