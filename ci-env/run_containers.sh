#!/bin/bash

echo 'Hello from script!'

RESULT=$(docker run --privileged -d -p 4444 -p 49153:22 -e PORT=4444 --name docker_host_ssh orius123/dind-ssh && echo -e "\nSUCCESS")
LAST_LINE=$(echo "${RESULT}" | tail -n 1)

if [ "${LAST_LINE}" != "SUCCESS" ]
then
  echo "Container startup failed.. retrying"

  echo "Removing container:"
  docker stop docker_host_ssh && docker rm docker_host_ssh

  echo "Restart Docker:"
  sudo restart docker
  echo "Resetting iptable:"
  sudo iptables -F

  echo "Docker status:"
  sudo service docker status

  echo "Sleeping.."
  sleep 5

  echo "Docker status:"
  sudo service docker status

  docker run --privileged -d -p 4444 -p 49153:22 -e PORT=4444 --name docker_host_ssh orius123/dind-ssh
fi
