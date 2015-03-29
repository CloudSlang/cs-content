#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Deletes two Docker containers.
#
# Inputs:
#   - db_container_ID - ID of the DB container
#   - linked_container_ID - ID of the linked container
#   - docker_host - Docker machine host
#   - docker_username - Docker machine username
#   - docker_password - Docker machine host password
# Outputs:
#   - error_message - error message
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: io.cloudslang.docker.containers

imports:
 docker_containers: io.cloudslang.docker.containers

flow:
  name: demo_clear_containers_wrapper
  inputs:
    - db_container_ID
    - linked_container_ID
    - docker_host
    - docker_username
    - docker_password
  workflow:
    - clear_db_container:
        do:
          docker_containers.clear_container:
            - container_ID: db_container_ID
            - docker_host
            - docker_username
            - docker_password
        publish:
          - error_message
    - clear_linked_container:
        do:
          docker_containers.clear_container:
            - container_ID: linked_container_ID
            - docker_host
            - docker_username
            - docker_password
        publish:
          - error_message
  outputs:
    - error_message
  results:
    - SUCCESS
    - FAILURE