resource "aws_lambda_function" "avei_lambda" {
  function_name = "avei-lambda-function"
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key = aws_s3_object.lambda_bucket_object.key
  
  source_code_hash = data.archive_file.dist.output_path
  # filename = "${data.archive_file.dist.output_path}"
  
  role = aws_iam_role.role.arn

  timeout = "10"
  
  handler = "dist/main.handler"
  runtime = "nodejs18.x"
  
  depends_on = [ aws_db_instance.avei_rds ]

  vpc_config {
    subnet_ids = [ aws_subnet.application_subnet-a.id, aws_subnet.application_subnet-b.id ]
    security_group_ids = [ aws_security_group.database.id ]
  }

  environment {
    variables = {
      DB_HOST = aws_db_instance.avei_rds.address
      DB_NAME = aws_db_instance.avei_rds.db_name
      DB_PASSWORD = aws_db_instance.avei_rds.password
      DB_PORT = aws_db_instance.avei_rds.port
      DB_USERNAME = aws_db_instance.avei_rds.username
    }
  }

}

resource "aws_lambda_function_url" "lambda_function_url" {
  function_name      = aws_lambda_function.avei_lambda.id
  authorization_type = "NONE"
  cors {
    # allow_methods = [ * ]
    allow_origins = [ "*" ]
  }
}

# resource "aws_lambda_permission" "lambda" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.avei_lambda.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_apigateway.}/*/*"
# }

# resource "aws_lambda_permission" "api_gateway" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.avei_lambda.function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_apigateway.v2_api.api.execution_arn}/*/*"
# }