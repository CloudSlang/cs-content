#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Prints information about the Swarm cluster - for now only the total number of containers in the cluster
#!               (including agent containers).
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
#!                       if true the SSH session used will be closed;
#!                       Valid: true, false
#! @input agent_forwarding: optional - whether to forward the user authentication agent
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.swarm.examples

imports:
  swarm: io.cloudslang.docker.swarm
  print: io.cloudslang.base.print

flow:
  name: print_cluster_info
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

  workflow:
    - retrieve_cluster_info:
        do:
          swarm.get_cluster_info:
            - swarm_manager_ip
            - swarm_manager_port
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
          - number_of_containers_in_cluster

    - print_number_of_containers:
        do:
          print.print_text:
            - text: "${'Number of containers in cluster: ' + number_of_containers_in_cluster}"
