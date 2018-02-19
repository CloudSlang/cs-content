#!/bin/bash

SUCCESS_TOKEN='SUCCESS'
CONTAINER_NAME='docker_host_ssh'

RESULT=$(docker run --privileged -d -p 4444 -p 49153:22 -e PORT=4444 --name ${CONTAINER_NAME} orius123/dind-ssh && echo -e "\n${SUCCESS_TOKEN}")
LAST_LINE=$(echo "${RESULT}" | tail -n 1)

if [ "${LAST_LINE}" != "${SUCCESS_TOKEN}" ]
then
  echo "Container startup failed.. retrying"

  echo "Removing container:"
  docker stop ${CONTAINER_NAME} && docker rm ${CONTAINER_NAME}

  echo "Restart Docker:"
  sudo restart docker
  echo "Resetting iptables:"
  sudo iptables -F

  echo "Docker status:"
  sudo service docker status

  echo "Sleeping.."
  sleep 5

  echo "Docker status:"
  sudo service docker status

  docker run --privileged -d -p 4444 -p 49153:22 -e PORT=4444 --name ${CONTAINER_NAME} orius123/dind-ssh
fi