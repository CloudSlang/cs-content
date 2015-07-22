#!/bin/bash

# test CircleCI env vars
echo $CIRCLE_PR_NUMBER
echo $CIRCLE_BRANCH # first part
echo $CIRCLE_SHA1
echo $CIRCLE_BUILD_NUM # second part

# test CircleCI env vars
echo ${CIRCLE_PR_NUMBER}
echo ${CIRCLE_BRANCH} # first part
echo ${CIRCLE_SHA1}
echo ${CIRCLE_BUILD_NUM} # second part

COREOS_MACHINE_NAMES="ci-${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}-coreos-1 ci-${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}-coreos-2 ci-${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}-coreos-3"
for COREOS_MACHINE in $COREOS_MACHINE_NAMES
do
  STATUS_CODE=$(curl -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $DO_API_TOKEN" \
  -d "{\"name\":\"$COREOS_MACHINE\",\"region\":\"ams3\",\"size\":\"512mb\",\
  \"image\":\"coreos-stable\",\"ssh_keys\":[774367],\"backups\":false,\"ipv6\":false,\
  \"user_data\":\"#cloud-config\n\ncoreos:\n  etcd:\n    discovery: https://discovery.etcd.io/84b281229d938ba03540624f0252f894\n    \
  addr: $private_ipv4:4001\n    peer-addr: $private_ipv4:7001\n  fleet:\n    public-ip: $private_ipv4\n    metadata: public_ip=$public_ipv4\n  \
  units:\n    - name: etcd.service\n      command: start\n    - name: fleet.service\n      command: start\",\"private_networking\":true}" \
  "https://api.digitalocean.com/v2/droplets" | grep "HTTP/1.1" | awk '{print $2}')

  if [ "$STATUS_CODE" = "200" ]
  then
    echo "$COREOS_MACHINE created"
  else
    echo "$COREOS_MACHINE NOT created - status code: $STATUS_CODE"
  fi
done
