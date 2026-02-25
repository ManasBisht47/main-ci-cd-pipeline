module "iam"{
   source = "../../modules/iam"
   environment="dev"
}

module "s3"{
    source = "../../modules/s3"
    bucket_name="dev-data-pipeline-manas2026"
}

module "lambda"{
  source = "../../modules/lambda"

  filename      = "../../../lambda_func/lambda.zip"
  function_name = "dev-lambda-function"
  role          = module.iam.lambda_role_arn
  handler       = "lambda.lambda_handler"
  source_code_hash = "../../../lambda_func/lambda.zip"
  layers="arn:aws:lambda:ap-south-1:336392948345:layer:AWSSDKPandas-Python311:26"
  

 

  runtime = "python3.11"
  
}