#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

PREFIX_NAME="$1"
PUBLIC_GATEWAY="$2"

VPC_NAME="${PREFIX_NAME}-vpc"

set -e

VPC_ID=$(ibmcloud is vpcs | grep "${VPC_NAME}" | sed -E "s/^([A-Za-z0-9-]+).*/\1/g")

if [[ -n "${VPC_ID}" ]]; then
  echo "VPC id found: ${VPC_NAME}"
  exit 1
fi

exit 0