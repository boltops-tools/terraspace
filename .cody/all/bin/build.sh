#!/bin/bash

set -eu

# will build from /tmp because terraspace/Gemfile may interfere
cd /tmp

export PATH=~/bin:$PATH # ~/bin/terraspace wrapper

set -x

git clone https://github.com/boltops-tools/terraspace-graph-demo
cd terraspace-graph-demo

# Rewrite the Gemfile to use the local terraspace gem for testing
cat << EOF > Gemfile
source "https://rubygems.org"
gem "terraspace", path: "$CODEBUILD_SRC_DIR", submodules: true
gem "rspec-terraspace", git: "https://github.com/boltops-tools/rspec-terraspace", branch: "master"
gem "terraspace_plugin_aws", git: "https://github.com/boltops-tools/terraspace_plugin_aws", branch: "master"
EOF
bundle

# Uncomment to enable logger level debug
# cat << EOF > config/app.rb
# Terraspace.configure do |config|
#   config.logger.level = :debug
# end
# EOF

terraspace all up -y
terraspace clean all -y
terraspace all down -y
