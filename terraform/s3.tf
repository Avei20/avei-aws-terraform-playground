locals {
  upload_file = data.archive_file.dist.output_path
}
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "avei-lambda-bucket2"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  acl    = "private"
  bucket = aws_s3_bucket.lambda_bucket.id
  depends_on = [ aws_s3_bucket_ownership_controls.s3_bucket_ownership_controls ]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership_controls" {
  bucket = aws_s3_bucket.lambda_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket              = aws_s3_bucket.lambda_bucket.id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_object" "lambda_bucket_object" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "v1/${aws_s3_bucket.lambda_bucket.id}-${local.now}.zip"
  source = data.archive_file.dist.output_path
  etag   = fileexists(local.upload_file) ? filemd5(local.upload_file) : "no-etag"
}


# resource "aws_s3_bucket" "lambda_bucket" {
#   bucket = "avei-lambda-bucket"
#   force_destroy = true
# }

# resource "aws_s3_bucket_acl" "bucket_acl" {
#   acl = "private"
#   bucket = aws_s3_bucket.lambda_bucket.id
# }

# resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
#   bucket = aws_s3_bucket.lambda_bucket.id
#   block_public_acls = true
#   block_public_policy = true
# }

# resource "aws_s3_object" "lambda_bucket_object" {
#   bucket = aws_s3_bucket.lambda_bucket.id
#   key = "v${aws_s3_bucket.lambda_bucket.id}.zip"
#   source = data.archive_file.dist.output_path
#   etag = fileexists(local.upload_file) ? filemd5(local.upload_file) : "no-etag"
# }