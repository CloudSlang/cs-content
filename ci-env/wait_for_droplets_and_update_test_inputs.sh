#!/bin/bash

inc_and_sleep()
{
  ((WAITING_TIME+=SLEEP_INTERVAL))
  sleep ${SLEEP_INTERVAL}
}

DROPLET_ID_ACC=$(cat "droplets_${CIRCLE_BUILD_NUM}.txt")
SLEEP_INTERVAL=5 # 5 sec
TIMEOUT=300 # 5 mins

# retrieve IPv4 addresses of droplets
for DROPLET_ID in ${DROPLET_ID_ACC}
do
  DROPLET_STATUS=''
  WAITING_TIME=0
  while [ "$DROPLET_STATUS" != "active" ] && [ "$WAITING_TIME" -lt "$TIMEOUT" ]
  do
    CURL_OUTPUT=$(curl -i -s -L -X GET -H 'Content-Type: application/json' -H "Authorization: Bearer ${DO_API_TOKEN}" \
    "https://api.digitalocean.com/v2/droplets/$DROPLET_ID")
    # echo "CURL_OUTPUT - GET DROPLET BY ID: $CURL_OUTPUT"

    STATUS_CODE=$(echo "$CURL_OUTPUT" | grep "Status" | awk '{print $2}')
    # echo "STATUS_CODE: $STATUS_CODE"

    if [ "$STATUS_CODE" = "200" ]
    then
      echo "Droplet($DROPLET_ID) information retrieved successfully"

      RESPONSE_BODY_JSON=$(echo "$CURL_OUTPUT" | grep "ip_address")
      # echo "RESPONSE_BODY_JSON: ${RESPONSE_BODY_JSON}"

      if [ "${RESPONSE_BODY_JSON}" = "" ]
      then
        inc_and_sleep
      else
        DROPLET_STATUS=$(\
        echo "$RESPONSE_BODY_JSON" | python -c \
'
import json,sys;
obj = json.load(sys.stdin);
print obj["droplet"]["status"];
'\
      )
        echo "Droplet($DROPLET_ID) status: ${DROPLET_STATUS}"

        if [ "$DROPLET_STATUS" = "active" ]
        then
          IP_ADDRESS=$(\
          echo "$RESPONSE_BODY_JSON" | python -c \
'
import json,sys;
obj = json.load(sys.stdin);
ipv4_list = obj["droplet"]["networks"]["v4"];
public_ipv4_list = filter(lambda x : x["type"] == "public", ipv4_list);
print public_ipv4_list[0] if len(public_ipv4_list) > 0 else "";
'\
        )
          echo "Droplet($DROPLET_ID) IPv4 address: $IP_ADDRESS"

          DROPLET_IP_ADDRESS_ACC+="${IP_ADDRESS} "
          # echo "DROPLET_IP_ADDRESS_ACC: $DROPLET_IP_ADDRESS_ACC"
        else
          inc_and_sleep
        fi
      fi
    else
      echo "Problem occurred: retrieving droplet($DROPLET_ID) information - status code: $STATUS_CODE"
    fi
  done
  if [ "$DROPLET_STATUS" != "active" ]
  then
    echo "Droplet($DROPLET_ID) is not active after ${WAITING_TIME}"
    exit 1
  fi
done

# update inputs files to use actual IP addresses
DROPLET_IP_ARRAY=(${DROPLET_IP_ADDRESS_ACC})
find test -type f -exec sed -i "s/<coreos_host_1>/${DROPLET_IP_ARRAY[0]}/g" {} +

# create ssh private key
SSH_KEY_PATH=droplets_rsa
echo -e "${DO_DROPLET_SSH_PRIVATE_KEY}" > ${SSH_KEY_PATH}

# update inputs files to use actual ssh key
find test -type f -exec sed -i "s/<private_key_file>/${SSH_KEY_PATH}/g" {} +
