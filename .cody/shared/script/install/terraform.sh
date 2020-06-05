#!/bin/bash

set -eu

TERRAFORM_VERSION=0.12.26

mkdir /tmp/terraform
cd /tmp/terraform
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
mv terraform /usr/local/bin
