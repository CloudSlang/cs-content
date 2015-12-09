#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Builds a Docker image based on a Dockerfile.
#
# Inputs:
#   - docker_image - Docker image specifier e.g. 'docker_user/image_name:tag'
#   - workdir - optional - path to the directory that contains the Dockerfile - Default: current directory
#   - dockerfile_name - optional - name of the Dockerfile - Default: Dockerfile
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - path to the private key file
#   - character_set - optional - character encoding used for input stream encoding from target machine
#                              - Valid: 'SJIS', 'EUC-JP', 'UTF-8' - Default: 'UTF-8'
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - time in milliseconds to wait for command to complete - Default: 3000000 ms (50 min)
#   - close_session - optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#                                if 'true' the SSH session used will be closed; Valid: true, false
#   - agent_forwarding - optional - whether to forward the user authentication agent
# Outputs:
#   - image_id - ID of the created Docker image
# Results:
#   - SUCCESS - Docker image successfully built
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.docker.images

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
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
        overridable: false
    - command:
        default: >
            ${ 'docker build ' + dockerfile_name_expression + '-t="' + docker_image + '" ' + workdir }
        overridable: false

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
