#!/bin/bash

set -eux

export PATH=~/bin:$PATH

cat << 'EOF' > ~/.gemrc
---
:backtrace: false
:bulk_threshold: 1000
:sources:
- https://rubygems.org
:update_sources: true
:verbose: true
benchmark: false
install: "--no-ri --no-rdoc --no-document"
update: "--no-ri --no-rdoc --no-document"
EOF

# Order matters, terraspace install must come at the end
# Normally, user installs terraspace which in turn will install the gem dependencies.
# But we want to install the edge versions here, not the already release gems.
# We install the gem dependencies first to achieve this
gems="
rspec-terraspace
terraspace_plugin_aws
terraspace_plugin_azurerm
terraspace_plugin_google
"

function setup() {
  local name=$1
  if [ -d $name ]; then
    cd $name
    git pull
  else
    git clone https://github.com/boltops-tools/$name
    cd $name

    git submodule update --init
  fi

  bundle install # --without development test
  rake install
  cd -
}

mkdir -p ~/environment/terraspace-edge
cd ~/environment/terraspace-edge
for i in $gems ; do
  setup $i
done

# Ready to go back to the original terraspace source and install terraspace
cd $CODEBUILD_SRC_DIR # terraspace folder
bundle install
rake install

mkdir -p ~/bin
cat << EOF > ~/bin/terraspace
#!/bin/bash
# If there's a Gemfile, assume we're in a terraspace project with a Gemfile for terraspace
if [ -f Gemfile ]; then
  exec bundle exec $CODEBUILD_SRC_DIR/exe/terraspace "\$@"
else
  exec $CODEBUILD_SRC_DIR/exe/terraspace "\$@"
fi
EOF

cat ~/bin/terraspace

chmod a+x ~/bin/terraspace
