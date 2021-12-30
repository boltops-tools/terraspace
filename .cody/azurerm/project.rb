github_url("https://github.com/boltops-tools/terraspace.git")
linux_image("aws/codebuild/amazonlinux2-x86_64-standard:3.0")
environment_variables(
  # Used by .cody/azurerm/bin/az/configure.sh
  AZURE_APP_CLIENT_JSON: ssm("/terraspace/#{Cody.env}/azure_app_client_json"),
)
