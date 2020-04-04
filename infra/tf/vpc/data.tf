data "aws_security_group" "elb" {
  name   = "solocoin-elb-sg"
  vpc_id = module.vpc.vpc_id
}

data "aws_security_group" "app_servers" {
  name   = "app_servers"
  vpc_id = module.vpc.vpc_id
}
