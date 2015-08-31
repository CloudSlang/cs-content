#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Deletes all Docker images and containers from Docker Host.
#
# Inputs:
#   - docker_host - Docker machine host
#   - docker_username - Docker machine username
#   - docker_password - Docker machine password
#   - private_key_file - optional - path to private key file
#   - timeout - optional - time in milliseconds to wait for the command to complete - Default: 6000000
# Outputs:
#   - total_amount_of_images_deleted - number of deleted images
####################################################

namespace: io.cloudslang.docker.containers

imports:
 docker_images: io.cloudslang.docker.images

flow:
  name: clear_containers
  inputs:
    - docker_host
    - docker_username
    - docker_password:
        required: false
    - private_key_file:
        required: false
    - timeout:
        default: "'6000000'"
    - port:
        required: false
  workflow:
    - get_all_containers:
        do:
          get_all_containers:
            - host: docker_host
            - username: docker_username
            - password:
                default: docker_password
                required: false
            - all_containers:
                default: true
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
            - port:
                required: false
        publish:
          - all_containers: container_list

    - clear_all_containers:
        do:
          clear_container:
            - container_id: all_containers
            - docker_host
            - docker_username
            - docker_password:
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
            - port:
                required: false