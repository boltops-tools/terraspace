# Instead of using provider, probably better to use env vars:
#
# export GOOGLE_APPLICATION_CREDENTIALS=~/.gcp/credentials.json
# export GOOGLE_PROJECT=$(cat ~/.gcp/credentials.json  | jq -r '.project_id')
#
# Provide example anwyay:
#
# provider("google",
#   project: "...",
#   region:  "us-central1",
#   zone:    "us-central1-c",
# )
#

backend("gcs",
  bucket: "terraspace-state",
  prefix: default_state_prefix, # IE: development/vm => development/vm/default.tfstate
)
