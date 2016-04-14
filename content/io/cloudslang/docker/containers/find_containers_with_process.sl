#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
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

flow:
  name: find_containers_with_process
  inputs:
    - host
    - port:
        required: false
    - proc_command: 
        default: 'docker ps -q'
        overridable: false
    - username
    - password:
        required: false
    - process_name
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
          - container_list
        navigate:
          - SUCCESS: loop_runs_on_this_container
          - FAILURE: FAILURE
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
            - RUNNING: loop_get_name
            - NOT_RUNNING: loop_get_name
            - FAILURE: FAILURE
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
          - containers_with_process: >
                ${self['containers_with_process'] + container_name}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
            
  outputs:
    - containers_with_process
    - standard_err