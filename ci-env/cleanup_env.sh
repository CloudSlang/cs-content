#!/bin/bash

# print droplets
# cat < "droplets_${CIRCLE_BUILD_NUM}.txt"

# DROPLET_ID_ACC=$(cat < "droplets_${CIRCLE_BUILD_NUM}.txt")
# echo "DROPLET_ID_ACC: $DROPLET_ID_ACC"

for DROPLET_ID in ${DROPLET_ID_ACC}
do
  CURL_OUTPUT=$(curl -i -s -L -X DELETE -H 'Content-Type: application/json' -H "Authorization: Bearer $DO_API_TOKEN" \
  "https://api.digitalocean.com/v2/droplets/$DROPLET_ID")
  # echo "CURL_OUTPUT: $CURL_OUTPUT"

  STATUS_CODE=$(echo "$CURL_OUTPUT" | grep "Status" | awk '{print $2}')
  echo "STATUS_CODE: $STATUS_CODE"

  if [ "$STATUS_CODE" = "204" ]
  then
    echo "Droplet($DROPLET_ID) deleted successfully"
  else
    echo "Problem occurred: destroying droplet($DROPLET_ID) - status code: $STATUS_CODE"
  fi
done
