#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates a Swarm cluster.
#! @input swarm_image: optional - Docker image used by the Swarm container - Default: swarm (latest)
#! @input host: Docker machine host
#! @input port: optional - SSH port
#! @input username: Docker machine username
#! @input password: optional - Docker machine password
#! @input private_key_file: optional - path to private key file
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: optional - whether to use PTY - Valid: true, false
#! @input timeout: optional - time in milliseconds to wait for the command to complete
#! @input close_session: optional - if false SSH session will be cached for future calls during the life of the flow,
#!                       if true the SSH session used will be closed;
#!                       Valid: true, false
#! @input agent_forwarding: optional - whether to forward the user authentication agent
#! @output cluster_id: ID of the created cluster
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.swarm

imports:
  containers: io.cloudslang.docker.containers

flow:
  name: create_cluster
  inputs:
    - swarm_image: 'swarm'
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
    - create_cluster:
        do:
          containers.run_container:
            - detach: false
            - container_params: '--rm'
            - container_command: 'create'
            - image_name: ${swarm_image}
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
          - cluster_id: ${container_id}
  outputs:
    - cluster_id
