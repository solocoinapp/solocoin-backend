resource "aws_elb" "web-elb" {
  name = "coronago-app-elb"

  # The same availability zone as our instances
  #  availability_zones = "${split(",", var.availability_zones)}"
  subnets = flatten("${var.public_subnet_ids}")

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}

