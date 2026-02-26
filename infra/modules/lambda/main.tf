resource "aws_lambda_function" "my_lambda" {
  filename      = var.filename
  function_name = var.function_name
  role          = var.role
  handler       = var.handler
  source_code_hash = filebase64sha256(var.source_code_hash)
 

  runtime = var.runtime
  layers=var.layers
  environment {
  variables = var.environment_variables
  timeout=var.timeout
  memory_size=var.memory_size
}
}

data "archive_file" "python_to_zip" {
  type        = "zip"
  source_file = "../../../lambda_func/lambda.py"
  output_path = "../../../lambda_func/lambda.zip"
}