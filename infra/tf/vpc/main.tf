variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "ap-south-1"
}

provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    key            = "tf/vpc/v1"
    bucket         = "solocoinapp-backend"
    dynamodb_table = "solocoinapp-backend"
    region         = "ap-south-1"
    profile        = "default"
  }
}
