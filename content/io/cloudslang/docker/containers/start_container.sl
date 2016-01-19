#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Starts a specified Docker container.
#
# Inputs:
#   - container_id - ID of the container to be started
#   - container_params - optional - command parameters - Default: none
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - absolute path to private key file
#   - arguments - optional - arguments to pass to command
#   - character_set - optional - character encoding used for input stream encoding from target machine
#                             - Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for the command to complete
#   - close_session - optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#                               if 'true' the SSH session used will be closed; Valid: true, false
# Outputs:
#   - container_id - ID of the container that was started
#   - error_message - error message
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: start_container
  inputs:
    - container_id
    - container_params:
        required: false
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
    - container_params_cmd: ${container_params + ' ' if bool(container_params) else ''}
        overridable: false
    - command:
        default: ${'docker start ' + container_params_cmd + ' ' + container_id}
        overridable: false
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - close_session:
        required: false

  workflow:
    - start_container:
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
            - agentForwarding
        publish:
          - return_result
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE
          FAIL_VALIDATE_SSH: FAILURE

  outputs:
    - container_id: return_result
    - error_message: ${'' if 'STDERR' not in locals() else STDERR if return_code == '0' else return_result}
