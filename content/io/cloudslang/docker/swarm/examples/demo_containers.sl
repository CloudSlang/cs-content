#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Demo flow for creating containers in a Swarm cluster.
#!               Creates two containers and displays the total number of containers (including agent containers) in the cluster
#!               after each creation.
#! @input swarm_manager_ip: IP address of the machine with the Swarm manager container
#! @input swarm_manager_port: port used by the Swarm manager container
#! @input host: Docker machine host
#! @input port: optional - SSH port
#! @input username: Docker machine username
#! @input password: optional - Docker machine password
#! @input private_key_file: optional - path to private key file
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: SJIS, EUC-JP, UTF-8
#! @input pty: optional - whether to use PTY - Valid: true, false
#! @input timeout: optional - time in milliseconds to wait for the command to complete
#! @input close_session: optional - if false SSH session will be cached for future calls during the life of the flow,
#!                       if true the SSH session used will be closed;
#!                       Valid: true, false
#! @input agent_forwarding: optional - whether to forward the user authentication agent
#! @input container_name_1: name of the first container - Default: 'tomcat1'
#! @input image_name_1: Docker image for the first container - Default: 'tomcat'
#! @input container_name_2: name of the second container - Default: 'tomcat2'
#! @input image_name_2: Docker image for the second container - Default: same as image_name_1
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.swarm.examples

imports:
  swarm: io.cloudslang.docker.swarm
  print: io.cloudslang.base.print

flow:
  name: demo_containers
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
    - container_name_1: 'tomcat1'
    - image_name_1: 'tomcat'
    - container_name_2: 'tomcat2'
    - image_name_2: ${image_name_1}

  workflow:
    - print_cluster_info_1:
        do:
          swarm.examples.print_cluster_info:
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

    - print_container_message_1:
        do:
          print.print_text:
            - text: >
                ${'Creating container in cluster: ' + container_name_1 + ' (' + image_name_1 + ')'}

    - run_container_in_cluster_1:
        do:
          swarm.run_container_in_cluster:
            - swarm_manager_ip
            - swarm_manager_port
            - container_name: ${container_name_1}
            - image_name: ${image_name_1}
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

    - print_cluster_info_2:
        do:
          swarm.examples.print_cluster_info:
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

    - print_container_message_2:
        do:
          print.print_text:
            - text: >
                ${'Creating container in cluster: ' + container_name_2 + ' (' + image_name_2 + ')'}

    - run_container_in_cluster_2:
        do:
          swarm.run_container_in_cluster:
            - swarm_manager_ip
            - swarm_manager_port
            - container_name: ${container_name_2}
            - image_name: ${image_name_2}
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

    - print_cluster_info_3:
        do:
          swarm.examples.print_cluster_info:
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
