#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Returns all container names where a certain process runs.
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
#! @output runing_process: the names of the runing processes
#! @output standard_err: error message
#!!#
####################################################
namespace: io.cloudslang.docker.containers

imports:
  strings: io.cloudslang.base.strings

flow:
  name: find_containers_with_process
  inputs:
    - process_name
    - host
    - port:
        default: '22'
        required: false
    - proc_command: 
        default: 'docker ps -q'
        overridable: false
    - username
    - password:
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
    - containers_with_process:
        default: ''
        overridable: false
    - container_ids:
        default: ''
        overridable: false

  workflow:
    - get_containers:
        do:
          get_all_containers:
            - all_containers
            - ps_params
            - command:${proc_command}
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
          - container_list: ${container_list}
        navigate:
          - SUCCESS: check_container_list_not_empty
          - FAILURE: FAILURE
    - check_container_list_not_empty:
        do:
          strings.string_equals:
            - first_string: ${container_list}
            - second_string: ''
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: loop_runs_on_this_container
    - loop_runs_on_this_container:
        loop:
          for: container_id in container_list.split()
          do:
            check_run_process:
              - container_id
              - process_name
              - container_id_list: ${container_ids}
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
            - container_ids: ${container_id_list}
          navigate:
            - RUNNING: check_container_ids_not_empty
            - NOT_RUNNING: check_container_ids_not_empty
            - FAILURE: FAILURE
    - check_container_ids_not_empty:
        do:
          strings.string_equals:
            - first_string: ${container_ids}
            - second_string: ''
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: loop_get_name
    - loop_get_name:
        loop:
          for: container_id in container_ids.split()
          do:
            get_container_name:
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
          - container_name
        navigate:
          - SUCCESS: append_to_list
          - FAILURE: FAILURE
    - append_to_list:
        do:
          strings.append:
            - string: ${containers_with_process}
            - text: ${container_name + ' '}
        publish:
          - containers_with_process: ${result}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE          
  outputs:
    - containers_with_process
    - standard_err