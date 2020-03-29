provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {
    key            = "tf/redis/v1"
    bucket         = "coronagoapp-backend"
    dynamodb_table = "coronagoapp-backend"
    region         = "ap-south-1"
    profile        = "default"
  }
}
