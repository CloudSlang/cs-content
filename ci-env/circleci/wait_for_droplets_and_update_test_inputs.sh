#!/bin/bash

# parameters to the script:
#   - DROPLETS_FILE - droplets info is stored in this file (e.g. IDs)
#   - SLEEP_INTERVAL - optional - sleep time between successive droplet checks
#   - TIMEOUT - optional - maximum amount of time to wait for a droplet to be available
#   - DO_API_TOKEN - DigitalOcean personal access token
#   - DO_DROPLET_SSH_PRIVATE_KEY - content of the SSH private key as string used for DigitalOcean droplets
#   - COREOS_PLACEHOLDERS - names of CoreOS machine placeholders in test files, separated by space

inc_and_sleep()
{
  ((WAITING_TIME+=SLEEP_INTERVAL))
  sleep ${SLEEP_INTERVAL}
}

DROPLET_ID_ACC=$(cat ${DROPLETS_FILE})
SLEEP_INTERVAL=${SLEEP_INTERVAL:-5} # Default: 5 sec
TIMEOUT=${TIMEOUT:-600} # Default: 600 sec (10 mins)

# retrieve IPv4 addresses of droplets
for DROPLET_ID in ${DROPLET_ID_ACC}
do
  DROPLET_STATUS=''
  WAITING_TIME=0
  while [ "${DROPLET_STATUS}" != "active" ] && [ "${WAITING_TIME}" -lt "${TIMEOUT}" ]
  do
    CURL_OUTPUT=$(curl -i -s -L -X GET -H 'Content-Type: application/json' -H "Authorization: Bearer ${DO_API_TOKEN}" \
    "https://api.digitalocean.com/v2/droplets/${DROPLET_ID}")

    STATUS_CODE=$(echo "$CURL_OUTPUT" | grep "HTTP/1.1" | tail -1 | awk '{print $2}')

    if [ "${STATUS_CODE}" = "200" ]
    then
      echo "Droplet(${DROPLET_ID}) information retrieved successfully"

      RESPONSE_BODY_JSON=$(echo "${CURL_OUTPUT}" | grep "ip_address")

      if [ "${RESPONSE_BODY_JSON}" = "" ]
      then
        inc_and_sleep
      else
        DROPLET_STATUS=$(\
        echo "${RESPONSE_BODY_JSON}" | python -c \
'
if True:
        import json,sys;
        obj = json.load(sys.stdin);
        print obj["droplet"]["status"];
'\
        )
        echo "Droplet(${DROPLET_ID}) status: ${DROPLET_STATUS}"

        if [ "${DROPLET_STATUS}" = "active" ]
        then
          IP_ADDRESS=$(\
          echo "${RESPONSE_BODY_JSON}" | python -c \
'
if True:
          import json,sys;
          obj = json.load(sys.stdin);
          ipv4_container_list = obj["droplet"]["networks"]["v4"];
          public_ipv4_container_list = filter(lambda x : x["type"] == "public", ipv4_container_list);
          print public_ipv4_container_list[0]["ip_address"] if len(public_ipv4_container_list) > 0 else "";
'\
          )
          echo "Droplet(${DROPLET_ID}) IPv4 address: ${IP_ADDRESS}"

          DROPLET_IP_ADDRESS_ACC+="${IP_ADDRESS} "
        else
          inc_and_sleep
        fi
      fi
    else
      echo "Problem occurred: retrieving droplet(${DROPLET_ID}) information - status code: ${STATUS_CODE}"
      exit 1
    fi
  done
  if [ "${DROPLET_STATUS}" != "active" ]
  then
    echo "Droplet(${DROPLET_ID}) is not active after ${WAITING_TIME} seconds"
    exit 1
  fi
done

# create ssh private key
SSH_KEY_PATH=droplets_rsa
echo -e "${DO_DROPLET_SSH_PRIVATE_KEY}" > ${SSH_KEY_PATH}
chmod 0600 ${SSH_KEY_PATH}

# enable Docker Remote API on a New Socket - open TCP port
ITER_NR=0
for DROPLET_IP in ${DROPLET_IP_ADDRESS_ACC}
do
  # skip the first machine so Swarm manager can use that port
  ((ITER_NR+=1))
  if [ "${ITER_NR}" = "1" ]
  then
    continue
  fi

  LAST_LINE=$(ssh -i ${SSH_KEY_PATH} \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  core@${DROPLET_IP} \
  'sudo systemctl enable docker-tcp.socket \
  && sudo systemctl stop docker \
  && sudo systemctl start docker-tcp.socket \
  && sudo systemctl start docker \
  && echo -e "\nSUCCESS"' | tail -n 1)

  if [ "${LAST_LINE}" = "SUCCESS" ]
  then
    echo "Droplet(${DROPLET_IP}) - TCP socket activated for Docker"
    echo ${LAST_LINE}
  else
    echo "Problem occurred: Droplet(${DROPLET_IP}) - TCP socket activation for Docker"
    exit 1
  fi
done

# define swap space
for DROPLET_IP in ${DROPLET_IP_ADDRESS_ACC}
do
  CMD_OUTPUT=$(ssh -i ${SSH_KEY_PATH} \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  core@${DROPLET_IP} \
  'sudo fallocate -l 1G /swapfile && sudo chmod 600 /swapfile \
  && sudo mkswap /swapfile && sudo swapon /swapfile \
  && sudo sysctl vm.swappiness=10 && sudo sysctl vm.vfs_cache_pressure=50')

  FREE_CMD_OUTPUT=$(ssh -i ${SSH_KEY_PATH} \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  core@${DROPLET_IP} \
  'free -m')
  SWAP_SIZE=$(echo "$FREE_CMD_OUTPUT" | grep "Swap" | awk '{print $2}')

  if [ "${SWAP_SIZE}" == "1023" ]
  then
    echo "Swap space defined: ${CMD_OUTPUT}"
  else
    echo "Problem while defining swap space. Size: ${SWAP_SIZE} - OUTPUT: ${CMD_OUTPUT}"
    exit 1
  fi
done

# update inputs files to use actual IP addresses
DROPLET_IP_ARRAY=(${DROPLET_IP_ADDRESS_ACC})
COREOS_PLACEHOLDERS_ARRAY=(${COREOS_PLACEHOLDERS})
ITER_NR=0
for DROPLET_IP in ${DROPLET_IP_ADDRESS_ACC}
do
  find test -type f -exec sed -i "s/${COREOS_PLACEHOLDERS_ARRAY[ITER_NR]}/${DROPLET_IP_ARRAY[ITER_NR]}/g" {} +
  ((ITER_NR+=1))
done

# update inputs files to use actual ssh public key ID
# find test -type f -exec sed -i "s/<ssh_public_key_id>/${DO_DROPLET_SSH_PUBLIC_KEY_ID}/g" {} +

# update inputs files to use actual ssh private key
find test -type f -exec sed -i "s/<private_key_file>/${SSH_KEY_PATH}/g" {} +

# update inputs files with build number
# find test -type f -exec sed -i "s/<build_number>/${CIRCLE_BUILD_NUM}/g" {} +

# update inputs files with DigitalOcean token
# find test -type f -exec sed -i "s/<digital_ocean_token>/${DO_API_TOKEN}/g" {} +
