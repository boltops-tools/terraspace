#!/bin/bash

set -eu

# TERRAFORM_VERSION=latest
TERRAFORM_VERSION=1.2.4

git clone https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
export PATH="$HOME/.tfenv/bin:$PATH"
tfenv install $TERRAFORM_VERSION
tfenv use $TERRAFORM_VERSION

# Generate wrapper so dont have to worry about adding .tfenv/bin to PATH in codebuild env
cat << 'EOL' > /usr/local/bin/terraform
#!/bin/bash
export PATH="$HOME/.tfenv/bin:$PATH"
exec terraform "$@"
EOL
chmod +x /usr/local/bin/terraform
