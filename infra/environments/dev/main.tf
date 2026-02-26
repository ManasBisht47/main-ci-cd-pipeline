module "iam" {
  source      = "../../modules/iam"
  environment = "dev"
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = "dev-data-pipeline-manas2026"
}

module "lambda" {
  source = "../../modules/lambda"

  filename         = "../../../lambda_func/lambda.zip"
  function_name    = "dev-lambda-function"
  role             = module.iam.lambda_role_arn
  handler          = "lambda.lambda_handler"
  source_code_hash = "../../../lambda_func/lambda.zip"
  layers           = ["arn:aws:lambda:ap-south-1:336392948345:layer:AWSSDKPandas-Python311:26",
                      aws_lambda_layer_version.snowflake_layer.arn]
  runtime          = "python3.11"
    environment_variables = {
    SF_USER     = var.sf_username
    SF_PASSWORD = var.sf_password
    SF_ACCOUNT  = var.sf_account

  }
 
}
resource "aws_lambda_layer_version" "snowflake_layer" {
  filename   = "../../../snowflake-layer/snowflake_layer.zip"
  layer_name = "snowflake-layer"

  compatible_runtimes = ["python3.11"]
  compatible_architectures = ["x86_64"]

  source_code_hash = filebase64sha256("../../../snowflake-layer/snowflake_layer.zip")
}