backend("s3",
  bucket:         "terraspace-state",
  key:            ":region/:env/:build_dir/terraform.tfstate", # variable notation expanded by terraspace
  region:         ENV["AWS_REGION"],
  encrypt:        true,
  dynamodb_table: "terraform_locks",
)
