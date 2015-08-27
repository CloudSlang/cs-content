#!/bin/bash

echo 'Hello from script!'

# RESULT=$((docker run --privileged -d -p 4444 -p 49153:22 -e PORT=4444 --name docker_host_ssh orius123/dind-ssh && echo -e "\nSUCCESS") | tail -n 1)

#if [ "${RESULT}" = "SUCCESS" ]
#  then
#    echo "Droplet(${DROPLET_ID}) deleted successfully"
#  else
#    echo "Problem occurred: destroying droplet(${DROPLET_ID}) - status code: ${STATUS_CODE}"
#  fi