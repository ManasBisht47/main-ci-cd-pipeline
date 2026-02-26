module "iam" {
  source      = "../../modules/iam"
  environment = "${var.environment}"
}

module "s3" {
  source      = "../../modules/s3"
  
  bucket_name = "${var.environment}-data-pipeline-manas2026"
  }


module "lambda" {
  source = "../../modules/lambda"

  filename         = "../../../lambda_func/lambda.zip"
  function_name    = "${var.environment}-lambda-function"
  role             = module.iam.lambda_role_arn
  handler          = "lambda.lambda_handler"
  source_code_hash = "../../../lambda_func/lambda.zip"
  timeout=60
  layers           = ["arn:aws:lambda:ap-south-1:336392948345:layer:AWSSDKPandas-Python311:26",
                      module.snowflake_layer.layer_arn]
  runtime          = "python3.11"
    environment_variables = {
    SF_USER     = var.sf_username
    SF_PASSWORD = var.sf_password
    SF_ACCOUNT  = var.sf_account_identity
    ENV=var.environment

  }
 
}
module "snowflake_layer" {
  source= "../../modules/lambda_layer"
  filename   = "../../../snowflake-layer/snowflake_layer.zip"
  environment="${var.environment}"
  


  source_code_hash = "../../../snowflake-layer/snowflake_layer.zip"
}


module "event_bridge" {
  source = "../../modules/event_bridge"

  environment         = var.environment
  description         = "Trigger lambda daily at 8 PM IST"
  schedule_expression = "cron(30 14 * * ? *)"

  arn         = module.lambda.lambda_arn
  lambda_name = module.lambda.lambda_name
}