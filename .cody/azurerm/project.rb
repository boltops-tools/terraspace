github("boltops-tools/terraspace")
image("aws/codebuild/amazonlinux2-x86_64-standard:3.0")
env_vars(
  # Used by .cody/azurerm/bin/az/configure.sh
  AZURE_APP_CLIENT_JSON: ssm("/terraspace/#{Cody.env}/azure_app_client_json"),
  TS_ORG: "qa",
  TS_TOKEN: "ssm:/#{Cody.env}/TS_TOKEN",
)
