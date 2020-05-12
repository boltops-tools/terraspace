backend("s3",
  bucket:         "terraspace-state",
  key:            default_state_path, # IE: development/vm/terraform.tfstate
  region:         ENV["AWS_REGION"],
  encrypt:        true,
  dynamodb_table: default_lock_table, # terraform_locks
)
