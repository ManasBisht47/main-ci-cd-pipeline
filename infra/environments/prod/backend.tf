terraform {
  backend "s3" {
    bucket = "manas-data-pipeline"
    key    = "qa/terraform.tfstate"
    region = "ap-south-1"
  }
}
