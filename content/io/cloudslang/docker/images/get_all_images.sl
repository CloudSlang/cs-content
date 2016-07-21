#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves a list of all the Docker images.
#! @input docker_options: optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input host: Docker machine host
#! @input port: optional - SSH port
#! @input username: Docker machine username
#! @input password: optional - Docker machine password
#! @input private_key_file: optional - absolute path to private key file
#! @input arguments: optional - arguments to pass to the command
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: optional - whether to use PTY - Valid: true, false
#! @input timeout: time in milliseconds to wait for command to complete
#! @input close_session: optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed; Valid: true, false
#! @input agent_forwarding: optional - whether to forward the user authentication agent
#! @output image_list: list containing REPOSITORY and TAG for all the Docker images
#! @result SUCCESS: SSH command succeeded
#! @result FAILURE: SSH command failed
#!!#
####################################################
namespace: io.cloudslang.docker.images

imports:
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: get_all_images
  inputs:
    - docker_options:
        required: false
    - docker_options_expression:
        default: ${ docker_options + ' ' if bool(docker_options) else '' }
        required: false
        private: true
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - command:
        default: >
            ${ "docker " + docker_options_expression + "images | awk '{print $1 \":\" $2}'" }
        private: true
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
    - get_images:
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
            - return_result
            - return_code
            - standard_err

    - verify_no_command_not_found_in_stderr:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ standard_err }
            - string_to_find: "command not found"
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: verify_no_daemon_in_stderr

    - verify_no_daemon_in_stderr:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ standard_err }
            - string_to_find: "daemon"
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: SUCCESS

  outputs:
    - image_list: >
          ${ return_result.replace("\n"," ")
          .replace("<none>:<none> ","")
          .replace(":latest", "")
          .replace("REPOSITORY:TAG ","") }
  results:
    - SUCCESS
    - FAILURE
