terraform {
  backend "gcs" {
    bucket = "terraspace-state"
    prefix = "<%= expansion(":REGION/:ENV/:BUILD_DIR") %>" # variable notation expanded by terraspace IE: us-central1/dev/modules/vm
  }
}
