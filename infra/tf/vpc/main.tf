provider "aws" {
  region = "ap-south-1"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=b76606e951b499d8ef84701a333e3795f100f3ef"

  name = "coronagoapp"

  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = true
  single_nat_gateway = true


  tags = {
    Environment = "PROD"
  }

  vpc_tags = {
    Name = "coronagoapp"

  }
}

