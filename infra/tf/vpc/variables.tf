variable "environment" {
  description = "The environment name in which the resources belong to"
  default     = "qa01"
}

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "ap-south-1"
}
