#!/bin/bash

COREOS_MACHINE_NAMES="ci-${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}-coreos-1 ci-${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}-coreos-2 ci-${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}-coreos-3"
for COREOS_MACHINE in $COREOS_MACHINE_NAMES
do
  CURL_OUTPUT=$(curl -i -s -L -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $DO_API_TOKEN" \
  -d "{\"name\":\"$COREOS_MACHINE\",\"region\":\"ams3\",\"size\":\"512mb\",\
  \"image\":\"coreos-stable\",\"ssh_keys\":[774367],\"backups\":false,\"ipv6\":false,\
  \"user_data\":\"#cloud-config\n\ncoreos:\n  etcd:\n    discovery: https://discovery.etcd.io/84b281229d938ba03540624f0252f894\n    \
  addr: $private_ipv4:4001\n    peer-addr: $private_ipv4:7001\n  fleet:\n    public-ip: $private_ipv4\n    metadata: public_ip=$public_ipv4\n  \
  units:\n    - name: etcd.service\n      command: start\n    - name: fleet.service\n      command: start\",\"private_networking\":true}" \
  "https://api.digitalocean.com/v2/droplets")

#  echo "CURL_OUTPUT: $CURL_OUTPUT"

  STATUS_CODE=$(echo $CURL_OUTPUT | awk '{print $2}')

  if [ "$STATUS_CODE" = "202" ]
  then
    DROPLET_DETAILS=$(echo "$CURL_OUTPUT" | grep "droplet")
    #  echo "DROPLET_DETAILS: $DROPLET_DETAILS"

    # split after `:` and `,` characters and extract the droplet ID
    DROPLET_ID_JUNK_ARRAY=(${DROPLET_DETAILS//:/ })
    DROPLET_ID_JUNK=${DROPLET_ID_JUNK_ARRAY[2]}
    DROPLET_ID_ARRAY=(${DROPLET_ID_JUNK//,/ })
    DROPLET_ID=${DROPLET_ID_ARRAY[0]}

    echo "$COREOS_MACHINE (ID: $DROPLET_ID) droplet creation request accepted"
  else
    echo "Problem occurred: $COREOS_MACHINE droplet creation request - status code: $STATUS_CODE"
  fi
done
