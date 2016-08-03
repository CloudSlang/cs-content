#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Returns the name of a container
#! @input container_id: container id
#! @input host: Docker machine host
#! @input port: optional - SSH port - Default: '22'
#! @input username: Docker machine username
#! @input password: Docker machine password - Default: ''
#! @input private_key_file: optional - absolute path to private key file - Default: ''
#! @input arguments: optional - arguments to pass to the command - Default ''
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8' - Default 'UTF-8'
#! @input pty: optional - whether to use PTY - Valid: true, false - Default: false
#! @input timeout: optional - time in milliseconds to wait for command to complete - Default: 90000
#! @input close_session: optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed;
#!                       Valid: true, false - Default: false
#! @input agent_forwarding: optional - the sessionObject that holds the connection if the close session is false - Default: ''
#! @output container_name: container name
#! @output standard_err: error message
#!!#
####################################################
namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: get_container_name
  inputs:
    - container_id
    - command:
        default: ${"CHARS_TO_DELETE=$(docker ps -af id=" + container_id + " | grep -b -o NAMES | awk 'BEGIN {FS="+ '":"'+"}{print $1}') && docker ps -af id="+ container_id +" | sed "+'"s/^.\{$CHARS_TO_DELETE\}//"'+" | awk 'NR==2'"}
        private: true
    - host
    - port:
        default: '22'
        required: false
    - username
    - password:
        sensitive: true
        default: ''
        required: false
    - private_key_file:
        default: ''
        required: false
    - arguments:
        default: ''
        required: false
    - character_set:
        default: 'UTF-8'
        required: false
    - pty:
        default: 'false'
        required: false
    - timeout:
        default: '90000'
        required: false
    - close_session:
        default: 'false'
        required: false
    - agent_forwarding:
        default: ''
        required: false

  workflow:
    - get_runing_processes:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file
            - command
            - arguments
            - character_set
            - pty
            - timeout
            - close_session
            - agent_forwarding

        publish:
          - container_name: ${return_result[:-1]}
          - standard_err

        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - container_name
    - standard_err

  results:
    - SUCCESS
    - FAILURE