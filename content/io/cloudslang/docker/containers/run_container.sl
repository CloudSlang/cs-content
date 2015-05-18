#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Pulls and runs a Docker container.
#
# Inputs:
#   - image_name - Docker image that will be assigned to the container
#   - container_name - container name
#   - container_params - optional - command parameters
#   - container_command - optional - container command
#   - host - Docker machine host
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - absolute path to private key file - Default: none
#   - arguments - optional - arguments to pass to command - Default: none
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false - Default: false
#   - timeout - optional - time in milliseconds to wait for the command to complete - Default: 90000
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false - Default: false
# Outputs:
#   - db_container_ID - ID of the container
#   - error_message - error message
# Results:
#   - SUCCESS
#   - FAILURE
####################################################
namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  images: io.cloudslang.docker.images

flow:
  name: run_container
  inputs:
    - container_name
    - container_params:
        default: "' '"
        required: false
    - image_name
    - container_command:
        default: "' '"
        required: false
    - command: "'docker run -d --name ' + container_name + ' ' + container_params + ' ' + image_name + ' ' + container_command"
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
    - characterSet:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - closeSession:
        required: false
    - agentForwarding:
        required: false

  workflow:
    - run_container:
        do:
          ssh.ssh_flow:
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                required: false
            - command
            - arguments:
                required: false
            - characterSet:
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - closeSession:
                required: false
            - agentForwarding:
                required: false
        publish:
          - returnCode
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE
          FAIL_VALIDATE_SSH: FAILURE

  outputs:
    - result
  results:
    - SUCCESS: returnCode == '0' and (not 'Error' in STDERR)
    - FAILURE