# Instead of using provider, probably better to use environment variables in your shell.
# IE: Put this in your ~/.bash_profile:
#
# export GOOGLE_APPLICATION_CREDENTIALS=~/.gcp/credentials.json
# export GOOGLE_PROJECT=$(cat ~/.gcp/credentials.json  | jq -r '.project_id')
#
# Here's an example of the google provider anyway also.
#
# provider "google" {
#   project = "REPLACE_ME"
#   region  = "us-central1"   # update to your region
#   zone    = "us-central1-a" # update to your zone
# }
#
# Docs: https://www.terraform.io/docs/providers/google/index.html
#