#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves a list of used Docker images.
#
# Inputs:
#   - docker_options - optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - absolute path to private key file - Default: none, required: false
#   - arguments - optional - arguments to pass to the command
#   - character_set - optional - character encoding used for input stream encoding from target machine
#                              - Valid: 'SJIS', 'EUC-JP', 'UTF-8' - Default: 'UTF-8'
#   - pty - optional - whether to use pty; valid values: true, false
#   - timeout - optional - time in milliseconds to wait for command to complete - Default: 30000000
#   - close_session - optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#                                if 'true' the SSH session used will be closed; Valid: true, false
#   - agent_forwarding - optional - whether to forward the user authentication agent
# Outputs:
#   - image_list - "\n" delimited list of IDs of used Docker images
# Results:
#   - SUCCESS - command succeeded
#   - FAILURE - command failed
####################################################

namespace: io.cloudslang.docker.images

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: get_used_images
  inputs:
    - docker_options:
        required: false
    - docker_options_expression:
        default: ${ docker_options + ' ' if bool(docker_options) else '' }
        overridable: false
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - command:
        default: >
         ${ "docker " + docker_options_expression + "ps -a | tail -n +2 | awk '{print $2}'" }
        overridable: false
    - arguments:
        required: false
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        default: "30000000"
        required: false
    - close_session:
        required: false
    - agent_forwarding:
        required: false

  workflow:
    - get_used_images:
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
          - image_list: '${ return_result.replace("\n"," ").replace(":latest", "") }'

  outputs:
    - image_list
  results:
    - SUCCESS
    - FAILURE