terraform {
  backend "s3" {
    key            = "tf/vpc/v1"
    bucket         = "coronagoapp-backend"
    dynamodb_table = "coronagoapp-backend"
    region         = "ap-south-1"
    profile        = "default"
  }
}
