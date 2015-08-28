#!/bin/bash

echo 'Hello from script!'

RESULT=$((docker run --privileged -d -p 32124:4444 -p 49153:22 -e PORT=32124 --name docker_host_ssh orius123/dind-ssh && echo -e "\nSUCCESS") | tail -n 1)

if [ "${RESULT}" != "SUCCESS" ]
then
  echo "Container startup failed.. retrying"
  docker stop docker_host_ssh && docker rm docker_host_ssh
  docker run --privileged -d -p 32123:4444 -p 49153:22 -e PORT=32123 --name docker_host_ssh orius123/dind-ssh
fi