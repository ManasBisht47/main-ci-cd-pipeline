module "iam"{
   source = "../../modules/iam"
   environment="prod"
}

module "s3"{
    source = "../../modules/s3"
    bucket_name="prod-data-pipeline-manas2026"
}

module "lambda"{
  source = "../../modules/lambda"

  filename      = "../../../lambda_func/lambda.zip"
  function_name = "prod-lambda-function"
  role          = module.iam.lambda_role_arn
  handler       = "lambda.lambda_handler"
 

  runtime = "python3.11"
}