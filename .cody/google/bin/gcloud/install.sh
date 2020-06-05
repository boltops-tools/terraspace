#!/bin/bash

set -eu

# https://cloud.google.com/sdk/docs/downloads-interactive?hl=ru#linux
# Non-interactive (silent) deployment
export PATH=~/google-cloud-sdk/bin:$PATH
curl https://sdk.cloud.google.com > install.sh
bash install.sh --disable-prompts
gcloud --version

cat << 'EOF' > /usr/local/bin/gcloud
#!/bin/bash
export PATH=~/google-cloud-sdk/bin:$PATH
exec gcloud "$@"
EOF

chmod a+x /usr/local/bin/gcloud
