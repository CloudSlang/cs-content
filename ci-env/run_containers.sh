#!/bin/bash

echo 'Hello from script!'

RESULT=$((docker run --privileged -d -p 4444 -p 49153:22 -e PORT=4444 --name docker_host_ssh orius123/dind-ssh && echo -e "\nSUCCESS") | tail -n 1)

if [ "${RESULT}" != "SUCCESS" ]
then
  echo "*** Container startup failed.. retrying **"
  docker ps -a
  echo "*** Removing container **"
  docker stop docker_host_ssh && docker rm docker_host_ssh
  echo "*** Restart Docker ***"
  sudo restart docker
  echo "*** Resetting iptable ***"
  sudo iptables -F
  docker ps -a
  docker run --privileged -d -p 4444 -p 49153:22 -e PORT=4444 --name docker_host_ssh orius123/dind-ssh
fi