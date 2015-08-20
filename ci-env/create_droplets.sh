#!/bin/bash

# generate discovery URL for the new CoreOS cluster and update the cloud-config file
DISCOVERY_URL=$(curl -s -X GET "https://discovery.etcd.io/new")
echo "DISCOVERY_URL: $DISCOVERY_URL"
DISCOVERY_URL_ESCAPED=$(echo ${DISCOVERY_URL} | sed 's/\//\\\//g')
sed -i "s/<discovery_url>/${DISCOVERY_URL_ESCAPED}/g" ci-env/cloud-config.yaml
# cat ci-env/cloud-config.yaml

COREOS_MACHINE_NAMES="\
ci-${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}-coreos-1 \
ci-${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}-coreos-2 \
ci-${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}-coreos-3"
for COREOS_MACHINE in ${COREOS_MACHINE_NAMES}
do
  CURL_OUTPUT=$(curl -i -s -X POST https://api.digitalocean.com/v2/droplets \
                -H 'Content-Type: application/json' \
                -H "Authorization: Bearer $DO_API_TOKEN" \
                -d "{
                  \"name\":\"${COREOS_MACHINE}\",
                  \"ssh_keys\":[${DO_DROPLET_SSH_PUBLIC_KEY_ID}],"'
                  "region":"ams3",
                  "size":"512mb",
                  "image":"coreos-stable",
                  "backups":false,
                  "ipv6":false,
                  "private_networking":true,
                  "user_data": "'"$(cat ci-env/cloud-config.yaml | sed 's/"/\\"/g')"'"
                }')
  # echo "CURL_OUTPUT: $CURL_OUTPUT"

  STATUS_CODE=$(echo "$CURL_OUTPUT" | grep "Status" | awk '{print $2}')

  if [ "$STATUS_CODE" = "202" ]
  then
    # echo "CURL_OUTPUT: $CURL_OUTPUT"

    DROPLET_DETAILS=$(echo "$CURL_OUTPUT" | grep "droplet")
    #  echo "DROPLET_DETAILS: $DROPLET_DETAILS"

    # split after `:` and `,` characters and extract the droplet ID
    DROPLET_ID_JUNK_ARRAY=(${DROPLET_DETAILS//:/ })
    DROPLET_ID_JUNK=${DROPLET_ID_JUNK_ARRAY[2]}
    DROPLET_ID_ARRAY=(${DROPLET_ID_JUNK//,/ })
    DROPLET_ID=${DROPLET_ID_ARRAY[0]}

    DROPLET_ID_ACC+="${DROPLET_ID} "

    echo "$COREOS_MACHINE (ID: $DROPLET_ID) droplet creation request accepted - status code: ${STATUS_CODE}"

    # store droplet IDs in a file to be accessible in other script
    echo ${DROPLET_ID_ACC} > "droplets_${CIRCLE_BUILD_NUM}.txt"
  else
    echo "Problem occurred: $COREOS_MACHINE droplet creation request - status code: ${STATUS_CODE}"
    exit 1
  fi
done
