terraform {
  backend "s3" {
    bucket         = "yurim-aws-platform-us-east-1-tfstate-0dc5ad"
    key            = "env/hom/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "yurim-aws-platform-us-east-1-tflock"
    encrypt        = true
  }
}
