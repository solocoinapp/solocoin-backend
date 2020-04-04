data "aws_vpc" "solocoinapp" {
  id = var.vpc_id
}

data "aws_security_group" "app_servers" {
  name = "app_servers"
}

data "aws_acm_certificate" "solocoin_cert" {
  domain = "*.solocoin.app"
  statuses = ["ISSUED"]
}
