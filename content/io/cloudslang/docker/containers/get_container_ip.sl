#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Gets the IP of the specified Docker container.
#
# Inputs:
#   - container_name - container name
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - Docker machine password
#   - private_key_file - optional - absolute path to private key file
#   - arguments - optional - arguments to pass to the command
#   - character_set - optional - character encoding used for input stream encoding from target machine
#                             - Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for command to complete
#   - close_session - optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#                                if 'true' the SSH session used will be closed;
#                              - Valid: true, false
#   - agent_forwarding - optional - the sessionObject that holds the connection if the close session is false
# Outputs:
#   - container_ip - IP of the specified container
#   - error_message - error message
# Results:
#   - SUCCESS
#   - FAILURE
####################################################
namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: get_container_ip
  inputs:
    - container_name
    - command: ${"docker inspect --format '{{ .NetworkSettings.IPAddress }}' " + container_name}
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
    - get_container_ip:
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
          - standard_err
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE
          FAIL_VALIDATE_SSH: FAILURE

  outputs:
    - container_ip: ${return_result[:-1]}
    - error_message: ${standard_err}
