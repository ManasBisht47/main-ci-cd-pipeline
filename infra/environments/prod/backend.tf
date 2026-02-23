terraform {
  backend "s3" {
    bucket = "manas-data-pipeline"
    key    = "prod/terraform.tfstate"
    region = "ap-south-1"
  }
}
