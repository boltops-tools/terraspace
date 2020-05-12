terraform {
  backend "gcs" {
    bucket = "terraspace-state"
    prefix = "<%= backend_expand("gcs", ":region/:env/:build_dir") %>" # variable notation expanded by terraspace IE: us-central1/development/modules/vm
  }
}
