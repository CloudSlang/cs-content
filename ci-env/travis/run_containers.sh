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

docker exec ${CONTAINER_NAME} echo "KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1" >> /etc/ssh/sshd_config