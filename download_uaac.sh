#!/bin/bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# get uaac token for OpsManager

set -e

if [[ "${OPSMGR_HOST}X" == "X" ]]; then
  echo "USAGE: OPSMGR_HOST=xxx download_uaac.sh"
  exit 1
fi

echo "Enter Client ID: opsman" 
echo "Enter Client secret: <EMPTY>" #Empty

gem install cf-uaac
uaac target https://$OPSMGR_HOST/uaa --skip-ssl-validation
uaac token owner get
uaac contexts