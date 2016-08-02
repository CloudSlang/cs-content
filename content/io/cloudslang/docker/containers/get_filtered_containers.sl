#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves a list of Docker container names. Containers can be filtered based on the images they are created from.
#! @input docker_options: optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input all_containers: optional - show all containers (both running and stopped) - Default: false, only running containers
#!                        any input that is different than empty string or false (as boolean type) changes its value to True
#! @input excluded_images: comma separated list of Docker images
#!                         the containers based on these images will not be included in the result list
#!                         Example: swarm:latest,tomcat:7
#! @input host: Docker machine host
#! @input port: optional - SSH port
#! @input username: Docker machine username
#! @input password: optional - Docker machine password
#! @input private_key_file: optional - path to private key file
#! @input character_set: optional - character encoding used for input stream encoding from target machine;
#!                       Valid: SJIS, EUC-JP, UTF-8
#! @input pty: optional - whether to use PTY - Valid: true, false
#! @input timeout: optional - time in milliseconds to wait for command to complete
#! @input close_session: optional - if false SSH session will be cached for future calls during the life of the flow,
#!                       if true the SSH session used will be closed;
#!                       Valid: true, false
#! @input agent_forwarding: optional - enables or disables the forwarding of the authentication agent connection
#! @output container_names: comma separated list of container names
#! @output container_ids: comma separated list of container IDs
#!!#
####################################################

namespace: io.cloudslang.docker.containers

imports:
  containers: io.cloudslang.docker.containers
  utils: io.cloudslang.docker.utils

flow:
  name: get_filtered_containers
  inputs:
    - docker_options:
        required: false
    - all_containers:
        default: false
    - excluded_images
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - close_session:
        required: false
    - agent_forwarding:
        required: false

  workflow:
    - get_containers_raw_output:
        do:
          containers.get_container_names:
            - docker_options
            - all_containers
            - host
            - port
            - username
            - password
            - private_key_file
            - character_set
            - pty
            - timeout
            - close_session
            - agent_forwarding
        publish:
          - raw_output

    - filter_containers_on_images:
        do:
          utils.filter_containers_raw_output:
            - raw_output
            - excluded_images
        publish:
          - container_names
          - container_ids
  outputs:
    - container_names
    - container_ids
