#!/bin/bash

set -eu

# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest
# Doesnt seem to have non-interactive install mode
# Workaround: https://github.com/Azure/azure-cli/issues/3376
export PATH=$PATH:~/.local/bin
pip install --user azure-cli --quiet
az --version

cat << 'EOF' > /usr/local/bin/az
export PATH=~/.local/bin:$PATH
exec az "$@"
EOF

chmod a+x /usr/local/bin/az
