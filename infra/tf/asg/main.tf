provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket         = "solocoin-tfstate"
    key            = "asg/v1/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "solocoin-locks"
    encrypt        = true
  }
}
