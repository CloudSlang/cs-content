#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will delete two docker containers.
#
#   Inputs:
#       - dbContainerID - ID of the DB container
#       - linkedContainerID - ID of the linked container
#       - dockerHost - Docker machine host
#       - dockerUsername - Docker machine username
#       - dockerPassword - Docker machine host password
#   Outputs:
#       - errorMessage - error message
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################

namespace: org.openscore.slang.docker.containers

imports:
 docker_containers: org.openscore.slang.docker.containers

flow:
  name: demo_clear_containers_wrapper
  inputs:
    - dbContainerID
    - linkedContainerID
    - dockerHost
    - dockerUsername
    - dockerPassword
  workflow:
    clear_db_container:
      do:
        docker_containers.clear_container:
          - containerID: "linkedContainerID"
          - dockerHost
          - dockerUsername
          - dockerPassword
    clear_linked_container:
      do:
        docker_containers.clear_container:
          - containerID: "dbContainerID"
          - dockerHost
          - dockerUsername
          - dockerPassword
  outputs:
    - errorMessage
  results:
    - SUCCESS
    - FAILURE