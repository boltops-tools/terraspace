#!/bin/bash

set -eu

mkdir -p ~/.gcp
# aws secretsmanager get-secret-value --secret-id terraspace/gcloud-credentials | jq '.SecretString | fromjson' > ~/.gcp/credentials.json
echo $GOOGLE_CREDS_JSON > ~/.gcp/credentials.json

# ~/.gcp/credentials.json
export GOOGLE_APPLICATION_CREDENTIALS=~/.gcp/credentials.json
export GOOGLE_PROJECT=$(cat $GOOGLE_APPLICATION_CREDENTIALS | jq -r '.project_id')

gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
gcloud config set project $GOOGLE_PROJECT
gcloud compute zones list --filter=region:us-central1
gcloud --version
