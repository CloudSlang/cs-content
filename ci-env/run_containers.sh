#!/bin/bash

echo 'Hello from script!'

RESULT=$((docker run --privileged -d -p 127.0.0.1:32123:4444 -p 127.0.0.1:32124:22 -e PORT=32123 --name docker_host_ssh orius123/dind-ssh && echo -e "\nSUCCESS") | tail -n 1)

if [ "${RESULT}" != "SUCCESS" ]
then
  echo "*** Container startup failed.. retrying ***"
  docker ps -a
  docker stop docker_host_ssh && docker rm docker_host_ssh
  echo "*** Resetting iptable **"
  sudo iptables -F
  docker run --privileged -d -p 4444 -p 22 -e PORT=4444 --name docker_host_ssh orius123/dind-ssh
fi