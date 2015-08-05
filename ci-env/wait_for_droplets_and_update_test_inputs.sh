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
  fi
done

# create ssh private key
SSH_KEY_PATH=droplets_rsa
echo -e "${DO_DROPLET_SSH_PRIVATE_KEY}" > ${SSH_KEY_PATH}
chmod 0600 ${SSH_KEY_PATH}

# enable Docker Remote API on a New Socket - open TCP port
ITER_NR=0
for DROPLET_ID in ${DROPLET_IP_ADDRESS_ACC}
do
  # skip for the first machine because manager needs to use that port
  if [ "${ITER_NR}" = "0" ]
  then
    continue
  else
    ((ITER_NR+=1))
  fi

  LAST_LINE=$(ssh -i ${SSH_KEY_PATH} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no core@${DROPLET_ID} \
  'sudo systemctl enable docker-tcp.socket \
  && sudo systemctl stop docker \
  && sudo systemctl start docker-tcp.socket \
  && sudo systemctl start docker \
  && echo -e "\nSUCCESS"' | tail -n 1)

  if [ "${LAST_LINE}" = "SUCCESS" ]
  then
    echo "Droplet($DROPLET_ID) - TCP socket activated for Docker"
  else
    echo "Problem occurred: Droplet($DROPLET_ID) - TCP socket activatation for Docker"
  fi
done

# update inputs files to use actual IP addresses
DROPLET_IP_ARRAY=(${DROPLET_IP_ADDRESS_ACC})
sed -i "s/<coreos_host>/${DROPLET_IP_ARRAY[0]}/g" test/io/cloudslang/coreos/cluster_docker_images_maintenance.inputs.yaml
sed -i "s/<cadvisor_host>/${DROPLET_IP_ARRAY[0]}/g" test/io/cloudslang/docker/cadvisor/*.inputs.yaml
sed -i "s/<manager_machine_ip>/${DROPLET_IP_ARRAY[0]}/g" test/io/cloudslang/docker/swarm/*.inputs.yaml
sed -i "s/<agent_machine_ip>/${DROPLET_IP_ARRAY[1]}/g" test/io/cloudslang/docker/swarm/*.inputs.yaml

# update inputs files to use actual ssh key
sed -i "s/<private_key_file>/${SSH_KEY_PATH}/g" test/io/cloudslang/coreos/cluster_docker_images_maintenance.inputs.yaml
sed -i "s/<private_key_file>/${SSH_KEY_PATH}/g" test/io/cloudslang/docker/cadvisor/*.inputs.yaml
sed -i "s/<private_key_file>/${SSH_KEY_PATH}/g" test/io/cloudslang/docker/swarm/*.inputs.yaml
