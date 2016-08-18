#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
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
#! @input password: optional - Docker machine password
#! @input private_key_file: optional - absolute path to private key file
#! @input arguments: optional - arguments to pass to the command - Default ''
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8' - Default 'UTF-8'
#! @input pty: optional - whether to use PTY - Valid: true, false - Default: false
#! @input timeout: optional - time in milliseconds to wait for command to complete - Default: 90000
#! @input close_session: optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed;
#!                       Valid: true, false - Default: false
#! @input agent_forwarding: optional - the sessionObject that holds the connection if the close session is false
#! @input containers_with_process: optional - an empty list of containers with processes that will be populated if found
#!                                 Default: ''
#! @input containers_with_processes: optional - names of all containers running the defined process
#!                                   Default: ''
#! @input container_ids: optional - a list containing the ID`s all the containers running
#!                       Default: ''
#! @output containers_found: the names of the containers with runing processes
#! @output standard_err: error message
#! @result SUCCESS: names of running containers retrieved successfully
#! @result FAILURE: something went wrong
#!!#
####################################################
namespace: io.cloudslang.docker.containers

imports:
  strings: io.cloudslang.base.strings
  containers: io.cloudslang.docker.containers

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
        private: true
    - username
    - password:
        sensitive: true
        required: false
    - private_key_file:
        required: false
    - arguments:
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
        required: false
    - containers_with_process:
        required: false
        default: ''
    - containers_with_processes:
        required: false
        default: ''
    - container_id_list:
        required: false
        default: ''
    - container_ids:
        required: false
        default: ''

  workflow:
    - get_containers:
        do:
          containers.get_all_containers:
            - all_containers
            - ps_params
            - command: ${proc_command}
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
          - container_list

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
            containers.check_run_process:
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
            - container_ids: ${container_id_result}


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
            containers.get_container_names_with_ids:
              - containers_with_process: ${containers_with_processes}
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
            - containers_with_processes: ${containers_with_process_found}
          navigate:
            - SUCCESS: SUCCESS
            - FAILURE: FAILURE

  outputs:
    - containers_found: ${containers_with_processes}
    - standard_err

  results:
    - SUCCESS
    - FAILURE
