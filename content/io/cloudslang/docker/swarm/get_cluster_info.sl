#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Displays system-wide Docker information about the Swarm cluster.
#
# Inputs:
#   - swarm_manager_ip - IP address of the machine with the Swarm manager container
#   - swarm_manager_port - port used by the Swarm manager container
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - path to private key file
#   - character_set - optional - character encoding used for input stream encoding from target machine; Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for command to complete
#   - close_session - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false
#   - agent_forwarding - optional - whether to forward the user authentication agent
# Outputs:
#   - docker_info - information returned by Docker
#   - number_of_containers_in_cluster - number of containers in the Swarm cluster (including agent containers)
#   - number_of_nodes_in_cluster - number of nodes in the Swarm cluster
####################################################

namespace: io.cloudslang.docker.swarm

imports:
  docker_utils: io.cloudslang.docker.utils
  strings: io.cloudslang.base.strings

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
        default: >
          '-H tcp://' + swarm_manager_ip + ':' + swarm_manager_port
        overridable: false

  workflow:
    - get_cluster_info:
        do:
          docker_utils.get_info:
            - docker_options
            - host
            - port:
                required: false
            - username
            - password:
                required: false
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
        publish:
          - docker_info
          - number_of_containers_in_cluster: >
              docker_info.split(': ')[1].split('\n')[0]
          - number_of_nodes_in_cluster: >
              docker_info.split('Nodes: ')[1].split('\n')[0]
  outputs:
    - docker_info
    - number_of_containers_in_cluster
    - number_of_nodes_in_cluster
