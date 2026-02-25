terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.33.0"
    }

    snowflake = {
      source = "snowflakedb/snowflake"
      version = "2.14.0"
  }
}
}

provider "aws" {
  region = "ap-south-1"
}