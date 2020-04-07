variable "environment" {
  description = "The environment name in which the resources belong to"
  default     = "qa01"
}

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
  description = "List of availability zones"
}

variable "key_name" {
  default     = "qa01_04_apr_2020"
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
  description = "Private subnet IDs to launch in"
  default     = ["subnet-0f5290ade80c3c4e4", "subnet-0a8307086c0b8f14b", "subnet-0181450a4d765c16d"]
}

variable "public_subnet_ids" {
  description = "Public subnet IDs to launch in"
  default     = ["subnet-0684c3096b01414c2"]
}

variable "vpc_id" {
  description = "Solocoin App VPC"
  default     = "vpc-053e32e2984ab43ca"
}
