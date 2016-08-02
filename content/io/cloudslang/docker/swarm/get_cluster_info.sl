#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Displays system-wide Docker information about the Swarm cluster.
#! @input swarm_manager_ip: IP address of the machine with the Swarm manager container
#! @input swarm_manager_port: port used by the Swarm manager container
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
#!                       if true the SSH session used will be closed; Valid: true, false
#! @input agent_forwarding: optional - whether to forward the user authentication agent
#! @output docker_info: information returned by Docker
#! @output number_of_containers_in_cluster: number of containers in the Swarm cluster (including agent containers)
#! @output number_of_nodes_in_cluster: number of nodes in the Swarm cluster
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.swarm

imports:
  utils: io.cloudslang.docker.utils

flow:
  name: get_cluster_info
  inputs:
    - swarm_manager_ip
    - swarm_manager_port
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
    - docker_options:
        default: "${'-H tcp://' + swarm_manager_ip + ':' + swarm_manager_port}"
        private: true

  workflow:
    - get_cluster_info:
        do:
          utils.get_info:
            - docker_options
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
          - docker_info
          - number_of_containers_in_cluster: >
              ${ docker_info.split(': ')[1].split('\n')[0] }
          - number_of_nodes_in_cluster: >
              ${ docker_info.split('Nodes: ')[1].split('\n')[0] }
  outputs:
    - docker_info
    - number_of_containers_in_cluster
    - number_of_nodes_in_cluster
