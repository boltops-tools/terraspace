terraform {
  backend "s3" {
    bucket         = "terraspace-state"
    key            = "<%= backend_expand("s3", ":region/:env/:build_dir/terraform.tfstate") %>" # variable notation expanded by terraspace IE: us-west-2/development/modules/vm/terraform.tfstate
    region         = "<%= ENV["AWS_REGION"] %>"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}
