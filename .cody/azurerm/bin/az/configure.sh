#!/bin/bash

set -eux

mkdir -p ~/.azure

set +x
# aws secretsmanager get-secret-value --secret-id terraspace/azure-client | jq -r '.SecretString | fromjson' > ~/.azure/app-client.json
echo $AZURE_APP_CLIENT_JSON > ~/.azure/app-client.json

# ~/.azure/app-client.json
export ARM_CLIENT_ID=$(cat ~/.azure/app-client.json | jq -r '.client_id')
export ARM_CLIENT_SECRET=$(cat ~/.azure/app-client.json | jq -r '.client_secret')
export ARM_SUBSCRIPTION_ID=$(cat ~/.azure/app-client.json | jq -r '.subscription_id')
export ARM_TENANT_ID=$(cat ~/.azure/app-client.json | jq -r '.tenant_id')

# non-interactive login with service principal
az login --service-principal \
  --username $ARM_CLIENT_ID \
  --password $ARM_CLIENT_SECRET \
  --tenant $ARM_TENANT_ID
set -x

git clone https://github.com/boltops-tools/azure_check.git
cd azure_check
bundle install
ruby azure_check.rb
