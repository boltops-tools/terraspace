backend("gcs",
  bucket: "terraspace-state",
  prefix: ":PROJECT/:REGION/:ENV/:BUILD_DIR" # variable notation gets expanded by terraspace IE: dev/vm => dev/vm/default.tfstate
)
