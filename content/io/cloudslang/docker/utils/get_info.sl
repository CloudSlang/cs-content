#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Displays system-wide Docker information.
#
# Inputs:
#   - docker_options - optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - path to private key file
#   - character_set - optional - character encoding used for input stream encoding from target machine;
#                   - Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for command to complete
#   - close_session - optional - if false SSH session will be cached for future calls during the life of the flow,
#                                if true the SSH session used will be closed;
#                              - Valid: true, false
#   - agent_forwarding - optional - whether to forward the user authentication agent
# Outputs:
#   - docker_info - information returned by Docker
# Results:
#   - SUCCESS - successful
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.docker.utils

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: get_info
  inputs:
    - docker_options:
        required: false
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
    - timeout:
        required: false
    - close_session:
        required: false
    - agent_forwarding:
        required: false
    - command:
        default: ${'docker ' + (docker_options + ' ' if bool(docker_options) else '') + 'info'}
        overridable: false

  workflow:
    - get_docker_info:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - privateKeyFile: ${private_key_file}
            - command
            - characterSet: ${character_set}
            - pty
            - timeout
            - closeSession: ${close_session}
            - agentForwarding: ${agent_forwarding}
        publish:
          - docker_info: ${returnResult}

    - evaluate_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${docker_info}
            - string_to_find: 'Containers'
  outputs:
    - docker_info