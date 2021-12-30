github_url("https://github.com/boltops-tools/terraspace.git")
linux_image("aws/codebuild/amazonlinux2-x86_64-standard:3.0")
environment_variables(
  # Used by .cody/google/bin/gcloud/configure.sh
  GOOGLE_CREDS_JSON: ssm("/terraspace/#{Cody.env}/google_creds_json"),
)
