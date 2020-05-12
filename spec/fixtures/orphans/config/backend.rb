backend("s3",
  bucket:         "demo-bucket",
  key:            ":region/:env/:build_dir/terraform.tfstate", # variable notation expanded by terraspace IE: us-west-2/development/modules/vm/terraform.tfstate
  region:         "us-west-2",
  encrypt:        true,
  dynamodb_table: "terraform_locks",
)
