data "aws_security_group" "elb" {
  name   = "${var.environment}-elb-sg"
  vpc_id = module.vpc.vpc_id
}

data "aws_security_group" "app_servers" {
  name   = "${var.environment}_app_servers"
  vpc_id = module.vpc.vpc_id
}
