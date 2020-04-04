data "aws_vpc" "coronagoapp" {
  id = var.vpc_id
}

data "aws_security_group" "app_servers" {
  name = "app_servers"
}
