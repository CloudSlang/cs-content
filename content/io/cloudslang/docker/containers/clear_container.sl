#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Deletes a Docker container.
#
# Inputs:
#   - container_ID - ID of the container to be deleted
#   - docker_host - Docker machine host
#   - docker_username - Docker machine username
#   - docker_password - Docker machine password
# Outputs:
#   - error_message - error message of the operation that failed
####################################################

namespace: io.cloudslang.docker.containers

imports:
 docker_containers: io.cloudslang.docker.containers

flow:
  name: clear_container
  inputs:
    - container_ID
    - docker_host
    - docker_username
    - docker_password
  workflow:
    - stop_container:
        do:
          docker_containers.stop_container:
            - containerID: container_ID
            - host: docker_host
            - username: docker_username
            - password: docker_password
        publish:
          - error_message

    - delete_container:
        do:
          docker_containers.delete_container:
            - containerID: container_ID
            - host: docker_host
            - username: docker_username
            - password: docker_password
        publish:
          - error_message
  outputs:
    - error_message
