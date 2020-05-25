backend("s3",
  bucket:         "terraspace-state",
  key:            ":REGION/:ENV/:BUILD_DIR/terraform.tfstate", # variable notation expanded by terraspace
  region:         ENV["AWS_REGION"],
  encrypt:        true,
  dynamodb_table: "terraform_locks",
)
