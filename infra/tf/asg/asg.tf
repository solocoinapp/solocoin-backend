resource "aws_autoscaling_group" "web-asg" {
  availability_zones   = split(",", var.availability_zones)
  name                 = "coronagoapp-asg"
  max_size             = var.asg_max
  min_size             = var.asg_min
  desired_capacity     = var.asg_desired
  force_delete         = true
  launch_configuration = aws_launch_configuration.web-lc.name
  load_balancers       = [aws_elb.web-elb.name]

  vpc_zone_identifier = var.private_subnet_ids
  tag {
    key                 = "Name"
    value               = "web-asg"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "web-lc" {
  name          = "coronagoapp-lc"
  image_id      = lookup(var.aws_amis, var.aws_region)
  instance_type = var.instance_type

  # Security group
  security_groups = [data.aws_security_group.app_servers.id]
  user_data       = file("userdata.sh")
  key_name        = var.key_name
}
