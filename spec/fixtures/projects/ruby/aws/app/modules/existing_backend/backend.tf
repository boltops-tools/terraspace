terraform {
  backend "s3" {
    bucket         = "terraspace-state"
    key            = "testkey"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}