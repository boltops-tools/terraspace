#!/bin/bash

set -eu

# will build from /tmp because terraspace/Gemfile may interfere
cd /tmp

export PATH=~/bin:$PATH # ~/bin/terraspace wrapper

set -x
terraspace new project infra --plugin none --examples
cd infra
terraspace new test demo --type stack
cd app/stacks/demo
terraspace test
