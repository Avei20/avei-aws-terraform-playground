terraform {
  required_providers {
    aws = {
      # profile = "default"
      # region  = "us-east-1"
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
  }

  backend "s3" {
    bucket = "avei-terraform-state"
    key    = "avei/terraform.tfstate"
    region = "us-east-1"
  }
}

# IAM Role for AWS Lambda 
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role-2"
    assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# # Lambda Function 
# resource "aws_lambda_function" "avei_lambda" {
#   function_name = "avei-lambda-function"
#   s3_bucket = aws_s3_bucket.lambda_bucket.id
#   s3_key = aws_s3_object.lambda_bucket_object.key
#   source_code_hash = data.archive_file.dist.output_path
#   # filename = "${data.archive_file.dist.output_path}"
#   timeout = "10"
#   role = aws_iam_role.role.arn
#   handler = "dist/main.handler"
#   runtime = "nodejs18.x"

# }

# resource "aws_lambda_permission" "lambda" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.avei_lambda.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
# }

# resource "aws_lambda_permission" "api_gateway" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.avei_lambda.function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
# }

