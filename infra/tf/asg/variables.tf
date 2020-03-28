variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "ap-south-1"
}

variable "aws_amis" {
  default = {
    "ap-south-1" = "ami-54d2a63b"
  }
}

variable "availability_zones" {
  default     = "ap-south-1a,ap-south-1b,ap-south-1c"
  description = "List of availability zones, use AWS CLI to find your "
}

variable "key_name" {
  default     = "deployer"
  description = "Name of AWS key pair"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "1"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "2"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "1"
}

variable "private_subnet_ids" {
  description  = "Private subnet IDs to launch in"
  default      = ["subnet-xxxxxxx","subnet-yyyyyyyyyy","subnet-zzzzzzzzzzzzz"]
}

variable "public_subnet_ids" {
  description  = "Public subnet IDs to launch in"
  default      = ["subnet-00000000000"]
}

variable "vpc_id" {
 description  = "The VPC ID to launch with"
 default      = "vpc-11111111111111"
}
