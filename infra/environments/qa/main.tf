module "iam" {
  source      = "../../modules/iam"
  environment = "dev"
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
                      aws_lambda_layer_version.snowflake_layer.arn]
  runtime          = "python3.11"
    environment_variables = {
    SF_USER     = var.sf_username
    SF_PASSWORD = var.sf_password
    SF_ACCOUNT  = var.sf_account_identity

  }
 
}
module "snowflake_layer" {
  source= "../../modules/lambda_layer"
  filename   = "../../../snowflake-layer/snowflake_layer.zip"
  

  

  source_code_hash = filebase64sha256("../../../snowflake-layer/snowflake_layer.zip")
}


module  "lambda_schedule" {
  source = "../../modules/event_bridge"
  
  description         = "Trigger lambda daily at 8 PM IST"
  schedule_expression = "cron(30 14 * * ? *)"
}



module "lambda_target" {
  source = "../../modules/event_bridge"
  rule      = aws_cloudwatch_event_rule.lambda_schedule.name
  target_id = "lambda"
  arn       = module.lambda.lambda_arn
}
module "allow_eventbridge" {
  source = "../../modules/event_bridge"
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
  description= "ALLOW EVENT BRIDGE INVOKE LAMBDA"
}