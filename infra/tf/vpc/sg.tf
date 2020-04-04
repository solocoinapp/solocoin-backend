resource "aws_security_group" "app_servers" {
  name        = "app_servers"
  description = "Allow inbound web traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Port 80 from ELB to application servers"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [data.aws_security_group.elb.id]
  }

  ingress {
    description = "Port 22 from world to application servers"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend"
  }
}

resource "aws_security_group" "databases" {
  name        = "databases"
  description = "Allow traffic from application SG to databases"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Port 5432 from application servers to databases"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = [module.vpc.vpc_cidr_block]
    security_groups = [aws_security_group.app_servers.id]
  }

  tags = {
    Name = "backend"
  }
}
