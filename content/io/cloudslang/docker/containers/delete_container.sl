#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Deletes the specified Docker container.
#
# Inputs
#   - container_id - ID of the container to be deleted
#   - docker_options - optional - options for the docker environment
#                               - from the construct: docker [OPTIONS] COMMAND [arg...]
#   - cmd_params - optional - command parameters
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - absolute path to private key file
#   - arguments - optional - arguments to pass to command
#   - character_set - optional - character encoding used for input stream encoding from target machine
#                             - Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#   - pty - optional - whether to use PTY
#                    - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for the command to complete
#   - close_session - optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#                                if 'true' the SSH session used will be closed;
#                              - Valid: true, false
#   - agent_forwarding - optional - the sessionObject that holds the connection if the close session is false
# Outputs:
#   - result - ID of the container that was deleted
#   - standard_err - error message
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: delete_container
  inputs:
    - container_id
    - docker_options:
        required: false
    - docker_options_expression:
        default: ${docker_options + ' ' if bool(docker_options) else ''}
        overridable: false
    - cmd_params:
        required: false
    - params:
        default: ${cmd_params + ' ' if bool(cmd_params) else ''}
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
    - command:
        default: ${'docker ' + docker_options_expression + 'rm ' + params + container_id}
        overridable: false
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
    - delete_container:
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
          - result: ${return_result.replace("\n","")}
          - exception
          - standard_out
          - standard_err
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE
          FAIL_VALIDATE_SSH: FAILURE
  outputs:
    - result
    - error_message: ${standard_err}

  results:
    - SUCCESS
    - FAILURE
