#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Pulls and runs a Docker container in a Swarm cluster.
#
# Inputs:
#   - swarm_manager_ip - IP address of the machine with the Swarm manager container
#   - swarm_manager_port - port used by the Swarm manager container
#   - container_name - optional - container name
#   - container_params - optional - command parameters
#   - container_command - optional - container command
#   - image_name - Docker image that will be assigned to the container
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - path to private key file
#   - character_set - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for the command to complete
#   - close_session - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false
#   - agent_forwarding - optional - whether to forward the user authentication agent
# Outputs:
#   - container_ID - ID of the container
# Results:
#   - SUCCESS - container created successfully
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.docker.swarm

imports:
  containers: io.cloudslang.docker.containers

flow:
  name: run_container_in_cluster
  inputs:
    - swarm_manager_ip
    - swarm_manager_port
    - container_name:
        required: false
    - container_params:
        required: false
    - container_command:
        required: false
    - image_name
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
    - run_container_in_cluster:
        do:
          containers.run_container:
            - docker_options
            - container_name:
                required: false
            - container_params:
                required: false
            - container_command:
                required: false
            - image_name
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - characterSet:
                default: character_set
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - closeSession:
                default: close_session
                required: false
            - agentForwarding:
                default: agent_forwarding
                required: false
        publish:
          - container_ID
  outputs:
    - container_ID
  results:
    - SUCCESS
    - FAILURE
