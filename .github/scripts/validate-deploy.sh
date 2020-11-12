#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

PREFIX_NAME="$1"
PUBLIC_GATEWAY="$2"

VPC_NAME="${PREFIX_NAME}-vpc"

set -e

VPC_ID=$(ibmcloud is vpcs | grep "${VPC_NAME}" | sed -E "s/^([A-Za-z0-9-]+).*/\1/g")

if [[ -z "${VPC_ID}" ]]; then
  echo "VPC id not found: ${VPC_NAME}"
  exit 1
fi

ibmcloud is vpc "${VPC_ID}"

SUBNETS=$(ibmcloud is subnets | grep "${VPC_NAME}")

if [[ -z "${SUBNETS}" ]]; then
  echo "Subnets not found: ${VPC_NAME}"
  exit 1
fi

if [[ "${PUBLIC_GATEWAY}" == "true" ]]; then
  PGS=$(ibmcloud is pubgws | grep "${VPC_NAME}")

  if [[ -z "${PGS}" ]]; then
    echo "Public gateways not found: ${VPC_NAME}"
    exit 1
  fi
else
  PGS=$(ibmcloud is pubgws | grep "${VPC_NAME}")

  if [[ -n "${PGS}" ]]; then
    echo "Public gateways found: ${VPC_NAME}"
    exit 1
  fi
fi

exit 0