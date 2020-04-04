resource "aws_elb" "web-elb" {
  name = "coronago-app-elb"

  # The same availability zone as our instances
  #availability_zones = split(",", var.availability_zones)
  subnets            = flatten(var.public_subnet_ids)
  security_groups    = [aws_security_group.elb.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  #listener {
  #  instance_port      = 80
  #  instance_protocol  = "http"
  #  lb_port            = 443
  #  lb_protocol        = "https"
  #  ssl_certificate_id = "arn:aws:acm:ap-northeast-2:575454090281:certificate/301cb342-a8ba-4061-951a-84bd83893c9b"
  #}

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}
