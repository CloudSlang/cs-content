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
#   - private_key_file - optional - absolute path to private key file - Default: none
#   - timeout - optional - time in milliseconds to wait for the command to complete - Defualt: 6000000
# Outputs:
#   - total_amount_of_images_deleted - number of deleted images
####################################################

namespace: io.cloudslang.docker.maintenance

imports:
 docker_containers: io.cloudslang.docker.containers
 docker_images: io.cloudslang.docker.images

flow:
  name: clear_docker_host
  inputs:
    - docker_host
    - docker_username
    - docker_password:
        required: false
    - private_key_file:
        required: false
    - timeout:
        default: "'6000000'"
  workflow:
    - get_all_containers:
        do:
          docker_containers.get_all_containers:
            - host: docker_host
            - username: docker_username
            - password:
                default: docker_password
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
        publish:
          - all_containers: container_list
    - clear_all_containers:
        do:
          docker_containers.clear_container:
            - container_ID: all_containers
            - docker_host
            - docker_username
            - docker_password:
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
    - clear_all_docker_images:
        do:
          docker_images.clear_unused_docker_images:
            - docker_host
            - docker_username
            - docker_password:
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
        publish:
          - amount_of_images_deleted
          - total_amount: amount_of_images_deleted + amount_of_dangling_images_deleted
  outputs:
    - total_amount_of_images_deleted: "'' if 'total_amount' not in locals() else total_amount"
