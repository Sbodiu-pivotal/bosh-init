#!/bin/bash

set -e

if [[
"${PIVNET_TOKEN}X" == "X" ||
"${UAA_ACCESS_TOKEN}X" == "X" ||
"${DOWNLOAD_URL}X" == "X" ||
"${OPSMGR_HOST}X" == "X" ]]; then
  echo "USAGE: PIVNET_TOKEN=xxx UAA_ACCESS_TOKEN=xxx DOWNLOAD_URL=xxx OPSMGR_HOST=xxx download-p-cf.sh"
  exit 1
fi

export LOCAL_FILE_NAME=${DOWNLOAD_URL:43:-42}.pivotal
export DOWNLOAD_EULA=${DOWNLOAD_URL:0:-28}/eula_acceptance

echo "Accept EULA authentication "
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token $PIVNET_TOKEN" -X POST $DOWNLOAD_EULA

echo "Attempting download of $LOCAL_FILE_NAME from $DOWNLOAD_URL"
wget -O "$LOCAL_FILE_NAME" --post-data="" --header="Authorization: Token $PIVNET_TOKEN" $DOWNLOAD_URL

echo "Attempting to upload of $LOCAL_FILE_NAME to $OPSMGR_HOST"
curl -k "https://${OPSMGR_HOST}/api/v0/available_products" -F "product[file]=@${LOCAL_FILE_NAME}" -X POST -H "Authorization: Bearer ${UAA_ACCESS_TOKEN}"

echo "$LOCAL_FILE_NAME finished uploading to Ops Manager"
