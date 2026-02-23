module "iam"{
   source = "../../modules/iam"
   environment="qa"
}

module "s3"{
    source = "../../modules/s3"
    bucket_name="qa-data-pipeline-manas2026"
}

module "lambda"{
  source = "../../modules/lambda"

  filename      = "../../../lambda_func/lambda.zip"
  function_name = "qa-lambda-function"
  role          = module.iam.lambda_role_arn
  handler       = "lambda.lambda_handler"
 

  runtime = "python3.11"
}