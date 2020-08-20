terraform {
  backend "PROVIDER_BACKEND" {
    bucket = "<%%= expansion("terraform-state-REPLACE_ME-REPLACE_ME-:ENV") %>" # expanded by terraspace
    prefix = "<%%= expansion("REPLACE_ME/:ENV/:BUILD_DIR") %>" # expanded by terraspace
  }
}
