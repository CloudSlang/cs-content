#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Deletes two Docker containers.
#! @input db_container_id: ID of the DB container
#! @input linked_container_id: ID of the linked container
#! @input docker_host: Docker machine host
#! @input port: optional - SSH port
#! @input docker_username: Docker machine username
#! @input docker_password: optional - Docker machine host password
#! @input private_key_file: optional - path to private key file
#! @output error_message: error message
#!!#
####################################################

namespace: io.cloudslang.docker.containers.examples

imports:
 containers: io.cloudslang.docker.containers

flow:
  name: demo_clear_containers_wrapper
  inputs:
    - db_container_id
    - linked_container_id
    - docker_host
    - port:
        required: false
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false

  workflow:
    - clear_db_container:
        do:
          containers.clear_container:
            - container_id: ${db_container_id}
            - docker_host
            - port
            - docker_username
            - docker_password
            - private_key_file
        publish:
          - error_message
    - clear_linked_container:
        do:
          containers.clear_container:
            - container_id: ${linked_container_id}
            - docker_host
            - port
            - docker_username
            - docker_password
            - private_key_file
        publish:
          - error_message
  outputs:
    - error_message
