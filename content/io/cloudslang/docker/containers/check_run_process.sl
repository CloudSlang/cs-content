#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks if a certain process runs on a container and appends it to a list.
#! @input container_id: container id
#! @input host: Docker machine host
#! @input port: optional - SSH port
#! @input username: Docker machine username
#! @input password: Docker machine password
#! @input process_name: name of the process
#! @input container_id_list: a list where container_id will be appended if process_name runs on the container
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
#! @output standard_err: error message

#!!#
####################################################
namespace: io.cloudslang.docker.containers

imports:
  regex: io.cloudslang.base.strings
  print: io.cloudslang.base.print

flow:
  name: check_run_process
  inputs:
    - container_id
    - process_name
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
    - container_id_list:
        default: ''
        required: false

  workflow:
    - get_running_processes:
        do:
          get_running_processes:
            - container_id
            - host
            - port
            - username
            - password
            - private_key_file
            - arguments
            - character_set
            - pty
            - timeout
            - close_session
            - agent_forwarding
        publish:
          - return_result
          - standard_err
        navigate:
          SUCCESS: check_if_is_running
          FAILURE: FAILURE
    - check_if_is_running:
        do:
          regex.match_regex:
            - regex: ${process_name}
            - text: ${return_result}
        navigate:
          MATCH: append_to_list
          NO_MATCH: NOT_RUNNING
    - append_to_list:
        do:
          print.print_text:
            - text: ${container_id}
        publish:
          - container_id_list: ${self['container_id_list'] + self['container_id'] + ' '}
        navigate:
          SUCCESS: RUNNING
          FAILURE: FAILURE
  results:
    - FAILURE: FAILURE
    - RUNNING
    - NOT_RUNNING: NO_MATCH
  outputs:
    - container_id_list
    - standard_err
