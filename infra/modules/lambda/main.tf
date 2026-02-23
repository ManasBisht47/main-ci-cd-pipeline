resource "aws_lambda_function" "my_lambda" {
  filename      = var.filename
  function_name = var.function_name
  role          = var.role
  handler       = var.handler
 

  runtime = var.runtime
}

data "archive_file" "python_to_zip" {
  type        = "zip"
  source_file = "../../../lambda_func/lambda.py"
  output_path = "../../../lambda_func/lambda.zip"
}