#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Builds a Docker image based on a Dockerfile.
#! @input docker_image: Docker image specifier - Example: 'docker_user/image_name:tag'
#! @input workdir: optional - path to the directory that contains the Dockerfile - Default: current directory
#! @input dockerfile_name: optional - name of the Dockerfile - Default: Dockerfile
#! @input host: Docker machine host
#! @input port: optional - SSH port
#! @input username: Docker machine username
#! @input password: optional - Docker machine password
#! @input private_key_file: optional - path to the private key file
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: optional - whether to use PTY - Valid: true, false
#! @input timeout: time in milliseconds to wait for command to complete - Default: 3000000 ms (50 min)
#! @input close_session: optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed; Valid: true, false
#! @input agent_forwarding: optional - whether to forward the user authentication agent
#! @output image_id: ID of the created Docker image
#! @result SUCCESS: Docker image successfully built
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.images

imports:
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: build_image
  inputs:
    - docker_image
    - workdir: "."
    - dockerfile_name: "Dockerfile"
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
    - timeout: "3000000"
    - close_session:
        required: false
    - agent_forwarding:
        required: false
    - dockerfile_name_expression:
        default: >
            ${ '' if dockerfile_name == 'Dockerfile' else '-f ' + workdir + '/' + dockerfile_name + ' ' }
        required: false
        private: true
    - command:
        default: >
            ${ 'docker build ' + dockerfile_name_expression + '-t="' + docker_image + '" ' + workdir }
        private: true

  workflow:
    - build_image_command:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file
            - command
            - character_set
            - pty
            - timeout
            - close_session
            - agent_forwarding
        publish:
          - image_id: >
              ${ standard_out.split('Successfully built ')[1].replace('\n', '')
              if ('Successfully built' in standard_out) else '' }
          - standard_out

    - check_occurrences:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ standard_out }
            - string_to_find: "Successfully built"
        publish:
          - number_of_occurrences: ${ str(return_result) }

    - validate_result:
        do:
          strings.string_equals:
            - first_string: "1"
            - second_string: ${ number_of_occurrences }
  outputs:
    - image_id
  results:
    - SUCCESS
    - FAILURE
