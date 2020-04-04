terraform {
  backend "s3" {
    key            = "tf/asg/v1"
    bucket         = "solocoinapp-backend"
    dynamodb_table = "solocoinapp-backend"
    region         = "ap-south-1"
    profile        = "default"
  }
}
