#!/bin/bash

set -eu

# cwd: /codebuild/output/src438337164/src/github.com/boltops-tools/terraspace
# will build from /tmp because terraspace/Gemfile may interfere
cd /tmp

export PATH=~/bin:$PATH # ~/bin/terraspace wrapper

# ~/.azure/app-client.json
export ARM_CLIENT_ID=$(cat ~/.azure/app-client.json | jq -r '.client_id')
export ARM_CLIENT_SECRET=$(cat ~/.azure/app-client.json | jq -r '.client_secret')
export ARM_SUBSCRIPTION_ID=$(cat ~/.azure/app-client.json | jq -r '.subscription_id')
export ARM_TENANT_ID=$(cat ~/.azure/app-client.json | jq -r '.tenant_id')

set -x
terraspace new project infra --examples --plugin azurerm
cd infra
terraspace new test demo --type stack
cd app/stacks/demo
terraspace test
