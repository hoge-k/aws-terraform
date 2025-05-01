#!/bin/sh

set -ex

TRRAFORM_VERSION="1.11.2"

wget -q "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip -d /usr/local/bin "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"