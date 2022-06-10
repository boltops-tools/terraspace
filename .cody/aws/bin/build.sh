#!/bin/bash

set -eu

# will build from /tmp because terraspace/Gemfile may interfere
cd /tmp

export PATH=~/bin:$PATH # ~/bin/terraspace wrapper

set -x
terraspace new project infra --examples
cd infra
$CODEBUILD_SRC_DIR/.cody/shared/script/update/gemfile.sh

terraspace new test demo --type stack
cd app/stacks/demo
cd test
$CODEBUILD_SRC_DIR/.cody/shared/script/update/gemfile.sh
cd -
terraspace test
