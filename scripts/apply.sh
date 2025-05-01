#!/bin/sh
set -ex
terraform init -input=false -no-color -backend=config="key=terraform.tfstate" -
backend-config="$S3_BUCKET"
terraform apply -auto-approve -no-nocolor