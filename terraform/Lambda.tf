resource "aws_lambda_function" "state_machine_lambdas" {
  function_name = "state_machine_lambdas"
  role = "ROLE_ARN"
  handler = "lambda_function.lambda_handler"
  s3_bucket = "avei-playground-bucket"
  s3_key = "lambda.zip"

  runtime = "python3.8"
  depends_on = [ aws_s3_bucket_object.lambda_s3_bucket_object ]
}