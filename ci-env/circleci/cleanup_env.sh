#!/bin/bash

exit 0

# parameters to the script:
#   - DROPLETS_FILE - droplets info is stored in this file (e.g. IDs)
#   - DO_API_TOKEN - DigitalOcean personal access token

DROPLET_ID_ACC=$(cat < ${DROPLETS_FILE})

for DROPLET_ID in ${DROPLET_ID_ACC}
do
  CURL_OUTPUT=$(curl -i -s -L -X DELETE -H 'Content-Type: application/json' -H "Authorization: Bearer ${DO_API_TOKEN}" \
  "https://api.digitalocean.com/v2/droplets/${DROPLET_ID}")

  STATUS_CODE=$(echo "${CURL_OUTPUT}" | grep "Status" | awk '{print $2}')
  echo "STATUS_CODE: ${STATUS_CODE}"

  if [ "${STATUS_CODE}" = "204" ]
  then
    echo "Droplet(${DROPLET_ID}) deleted successfully"
  else
    echo "Problem occurred: destroying droplet(${DROPLET_ID}) - status code: ${STATUS_CODE}"
  fi
done
