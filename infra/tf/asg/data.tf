data "aws_vpc" "qa01" {
  id = var.vpc_id
}

data "aws_security_group" "app_servers" {
  name = "app_servers"
}

data "aws_acm_certificate" "solocoin_cert" {
  domain = "*.solocoin.app"
  statuses = ["ISSUED"]
}
