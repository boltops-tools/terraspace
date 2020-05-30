terraform {
  backend "gcs" {
    bucket = "terraspace-state"
    prefix = "<%= backend_expand("gcs", ":REGION/:ENV/:BUILD_DIR") %>" # variable notation expanded by terraspace IE: us-central1/dev/modules/vm
  }
}
