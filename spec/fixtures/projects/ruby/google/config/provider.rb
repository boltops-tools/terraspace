# Instead of using provider, probably better to use env vars:
#
# export GOOGLE_APPLICATION_CREDENTIALS=~/.google/credentials.json
# export GOOGLE_PROJECT=$(cat ~/.google/credentials.json  | jq -r '.project_id')
#
# Providing example anyway:
#
# provider("google",
#   project: "...",
#   region:  "us-central1",
#   zone:    "us-central1-c",
# )
#

