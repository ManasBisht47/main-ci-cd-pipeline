terraform {
  backend "s3" {
    bucket = "manas-data-pipeline"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
  }
}
