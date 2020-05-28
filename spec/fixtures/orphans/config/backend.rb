backend("s3",
  bucket:         "demo-bucket",
  # hard-code region for spec only
  key:            "us-west-2/:ENV/:BUILD_DIR/terraform.tfstate", # variable notation expanded by terraspace IE: us-west-2/dev/modules/vm/terraform.tfstate
  region:         "us-west-2",
  encrypt:        true,
  dynamodb_table: "terraform_locks",
)
