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
$CODEBUILD_SRC_DIR/.cody/shared/script/update/gemfile.sh

terraspace new test demo --type stack
cd app/stacks/demo
cd test
$CODEBUILD_SRC_DIR/.cody/shared/script/update/gemfile.sh
cd -
terraspace test
