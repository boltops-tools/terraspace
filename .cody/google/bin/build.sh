#!/bin/bash

set -eu

# will build from /tmp because terraspace/Gemfile may interfere
cd /tmp

export PATH=~/bin:$PATH # ~/bin/terraspace wrapper

# ~/.gcp/credentials.json
export GOOGLE_APPLICATION_CREDENTIALS=~/.gcp/credentials.json
export GOOGLE_PROJECT=$(cat $GOOGLE_APPLICATION_CREDENTIALS | jq -r '.project_id')

set -x
terraspace new project infra --examples --plugin google
cd infra
terraspace new bootstrap_test
terraspace new project_test demo --examples --plugin google
terraspace test
