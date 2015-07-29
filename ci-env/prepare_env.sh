#!/bin/bash

DROPLET_ID_ACC=""
DROPLET_IP_ADDRESS_ACC=""

DISCOVERY_URL=$(curl -X GET "https://discovery.etcd.io/new")
echo "DISCOVERY_URL: $DISCOVERY_URL"
DISCOVERY_URL_ESCAPED=$(echo $DISCOVERY_URL | sed 's/\//\\\//g')
sed -i "s/<discovery_url>/${DISCOVERY_URL_ESCAPED}/g" ci-env/cloud-config.yaml
cat ci-env/cloud-config.yaml

COREOS_MACHINE_NAMES="ci-${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}-coreos-1 ci-${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}-coreos-2 ci-${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}-coreos-3"
for COREOS_MACHINE in $COREOS_MACHINE_NAMES
do
  CURL_OUTPUT=$(curl -i -s -X POST https://api.digitalocean.com/v2/droplets \
                -H 'Content-Type: application/json' \
                -H "Authorization: Bearer $DO_API_TOKEN" \
                -d "{
                  \"name\":\"${COREOS_MACHINE}\","'
                  "region":"ams3",
                  "size":"512mb",
                  "image":"coreos-stable",
                  "ssh_keys":[993143],
                  "backups":false,
                  "ipv6":false,
                  "private_networking":true,
                  "user_data": "'"$(cat ci-env/cloud-config.yaml | sed 's/"/\\"/g')"'"
                }')

  echo "CURL_OUTPUT: $CURL_OUTPUT"

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

    DROPLET_ID_ACC+="${DROPLET_ID} "

    echo "$COREOS_MACHINE (ID: $DROPLET_ID) droplet creation request accepted"
  else
    echo "Problem occurred: $COREOS_MACHINE droplet creation request - status code: $STATUS_CODE"
  fi
done

# store droplet IDs in a file to be accessible in cleanup script
# echo $DROPLET_ID_ACC
echo $DROPLET_ID_ACC > "droplets_${CIRCLE_BUILD_NUM}.txt"

# TODO: add waiting loop for droplet startup
sleep 60

# retrieve IPv4 addresses of droplets
for DROPLET_ID in $DROPLET_ID_ACC
do
  CURL_OUTPUT=$(curl -i -s -L -X GET -H 'Content-Type: application/json' -H "Authorization: Bearer $DO_API_TOKEN" \
  "https://api.digitalocean.com/v2/droplets/$DROPLET_ID")
  # echo "CURL_OUTPUT - GET DROPLET BY ID: $CURL_OUTPUT"

  STATUS_CODE=$(echo "$CURL_OUTPUT" | grep "Status" | awk '{print $2}')
  # echo "STATUS_CODE: $STATUS_CODE"

  if [ "$STATUS_CODE" = "200" ]
  then
    echo "Droplet($DROPLET_ID) information retrieved successfully"

    RESPONSE_BODY_JSON=$(echo "$CURL_OUTPUT" | grep "ip_address")
    # echo "IP_ADDRESS_JUNK: $RESPONSE_BODY_JSON"

    IP_ADDRESS=$(\
    echo "$RESPONSE_BODY_JSON" | python -c \
'
import json,sys;
obj = json.load(sys.stdin);
ipv4_list = obj["droplet"]["networks"]["v4"];
ip = ""
for ip_obj in ipv4_list:
  if ip_obj["type"] == "public":
    ip = ip_obj["ip_address"];
    break;
print ip;
'\
    )
    echo "Droplet($DROPLET_ID) IPv4 address: $IP_ADDRESS"

    DROPLET_IP_ADDRESS_ACC+="${IP_ADDRESS} "
    echo "DROPLET_IP_ADDRESS_ACC: $DROPLET_IP_ADDRESS_ACC"
  else
    echo "Problem occurred: retrieving droplet($DROPLET_ID) information - status code: $STATUS_CODE"
  fi
done

# update inputs files to use actual IP addresses
DROPLET_IP_ARRAY=($DROPLET_IP_ADDRESS_ACC)
sed -i "s/<coreos_host>/${DROPLET_IP_ARRAY[0]}/g" test/io/cloudslang/coreos/test_access_coreos_machine.inputs.yaml
sed -i "s/<coreos_host>/${DROPLET_IP_ARRAY[0]}/g" test/io/cloudslang/coreos/cluster_docker_images_maintenance.inputs.yaml

# create ssh private key
SSH_KEY_PATH=droplets_rsa
echo -e "$SSH_PRIVATE_KEY_CI_ENV_TEMP2" > $SSH_KEY_PATH
# ls -l .

# update inputs files to use actual ssh key
sed -i "s/<private_key_file>/${SSH_KEY_PATH}/g" test/io/cloudslang/coreos/test_access_coreos_machine.inputs.yaml
sed -i "s/<private_key_file>/${SSH_KEY_PATH}/g" test/io/cloudslang/coreos/cluster_docker_images_maintenance.inputs.yaml

cat test/io/cloudslang/coreos/test_access_coreos_machine.inputs.yaml
cat test/io/cloudslang/coreos/cluster_docker_images_maintenance.inputs.yaml
