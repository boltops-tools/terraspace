github("boltops-tools/terraspace")
image("aws/codebuild/amazonlinux2-x86_64-standard:3.0")
env_vars(
  # Used by .cody/azurerm/bin/az/configure.sh
  AZURE_APP_CLIENT_JSON: ssm("/terraspace/#{Cody.env}/azure_app_client_json"),
  INFRACOST_API_KEY: "ssm:/#{Cody.env}/INFRACOST_API_KEY",
  TS_API: "ssm:/#{Cody.env}/TS_API",
  TS_COST: true,
  TS_LOG_LEVEL: "info",
  TS_ORG: "qa",
  TS_TOKEN: "ssm:/#{Cody.env}/TS_TOKEN",
)
