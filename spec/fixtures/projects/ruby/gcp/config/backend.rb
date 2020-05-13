backend("gcs",
  bucket: "terraspace-state",
  prefix: ":project/:region/:env/:build_dir" # variable notation gets expanded by terraspace IE: development/vm => development/vm/default.tfstate
)
