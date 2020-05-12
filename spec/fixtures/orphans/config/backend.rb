backend("s3",
  bucket:         "demo-bucket",
  key:            default_state_path,
  region:         "us-west-2",
  encrypt:        true,
  dynamodb_table: "lock-table",
)
