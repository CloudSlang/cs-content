#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Deletes all Docker images and containers from a Docker Host.
#! @input docker_host: Docker machine host
#! @input docker_username: Docker machine username
#! @input docker_password: Docker machine password
#! @input private_key_file: optional - path to private key file
#! @input timeout: optional - time in milliseconds to wait for the command to complete - Default: '6000000'
#! @input port: optional - SSH port
#!!#
####################################################

namespace: io.cloudslang.docker.containers

imports:
 containers: io.cloudslang.docker.containers

flow:
  name: clear_containers
  inputs:
    - docker_host
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - timeout: '6000000'
    - port:
        required: false
  workflow:
    - get_all_containers:
        do:
          containers.get_all_containers:
            - host: ${docker_host}
            - username: ${docker_username}
            - password: ${docker_password}
            - all_containers: true
            - private_key_file
            - timeout
            - port
        publish:
          - all_containers: ${container_list}

    - clear_all_containers:
        do:
          containers.clear_container:
            - container_id: ${all_containers}
            - docker_host
            - docker_username
            - docker_password
            - private_key_file
            - timeout
            - port
