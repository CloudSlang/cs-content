#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks if a certain process runs on a container.
#! @input container_id: container name
#! @input host: Docker machine host
#! @input port: optional - SSH port
#! @input username: Docker machine username
#! @input password: Docker machine password
#! @input private_key_file: optional - absolute path to private key file
#! @input arguments: optional - arguments to pass to the command
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: optional - whether to use PTY - Valid: true, false
#! @input timeout: optional - time in milliseconds to wait for command to complete
#! @input close_session: optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed;
#!                       Valid: true, false
#! @input agent_forwarding: optional - the sessionObject that holds the connection if the close session is false
#! @output runing_process: the names of the runing processes
#! @output standard_err: error message
#!!#
####################################################
namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: get_container_name
  inputs:
    - container_id
    - command:
        default: ${"INCEPUT=$(docker ps -af id=" + container_id + " | grep -b -o NAMES | awk 'BEGIN {FS="+ '":"'+"}{print $1}') && docker ps -af id="+ container_id +" | sed "+'"s/^.\{$INCEPUT\}//"'+" | awk 'NR==2'"}
        overridable: false
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - arguments:
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
          - container_name: ${returnResult}
          - standard_err
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE


  outputs:
    - container_name
    - standard_err
