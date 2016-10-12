#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Registers the Swarm agent to the discovery service.
#! @input node_ip: IP address of the node the agent is running on. The node’s IP must be accessible from the Swarm Manager.
#! @input cluster_id: ID of the Swarm cluster
#! @input swarm_image: optional - Docker image the Swarm agent container is created from - Default: swarm (latest)
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
#! @output agent_container_id: ID of the created agent container
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
########################################################################################################

namespace: io.cloudslang.docker.swarm

imports:
  containers: io.cloudslang.docker.containers

flow:
  name: register_agent
  inputs:
    - node_ip
    - cluster_id
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
    - run_agent_container:
        do:
          containers.run_container:
            - container_command: ${'join --addr=' + node_ip + ':2375' + ' token://' + cluster_id}
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
          - agent_container_id: ${container_id}
  outputs:
    - agent_container_id
