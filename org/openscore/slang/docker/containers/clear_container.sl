#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will delete a Docker container.
#
#   Inputs:
#       - containerID - ID of the container to be deleted
#       - dockerHost - Docker machine host
#       - dockerUsername - Docker machine username
#       - dockerPassword - Docker machine password
#   Outputs:
#       - errorMessage - error message of the operation that failed
####################################################

namespace: org.openscore.slang.docker.containers

imports:
 docker_containers: org.openscore.slang.docker.containers

flow:
  name: clear_container
  inputs:
    - containerID
    - dockerHost
    - dockerUsername
    - dockerPassword
  workflow:
    stop_container:
      do:
        docker_containers.stop_container:
          - containerID
          - host: dockerHost
          - username: dockerUsername
          - password: dockerPassword
      publish:
        - errorMessage

    delete_container:
      do:
        docker_containers.delete_container:
          - containerID
          - host: dockerHost
          - username: dockerUsername
          - password: dockerPassword
      publish:
        - errorMessage
  outputs:
    - errorMessage
