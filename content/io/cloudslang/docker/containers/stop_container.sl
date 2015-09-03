#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Stop the specified Docker container.
#
# Inputs:
#   - container_id - ID of the container to be deleted
#   - docker_options - optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#   - cmd_params - optional - command parameters - Default: none
#   - host - Docker machine host
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file
#   - arguments - optional - arguments to pass to command - Default: none
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false - Default: false
#   - timeout - optional - time in milliseconds to wait for command to complete - Default: 90000
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false - Default: false
# Outputs:
#   - result - ID of the container that was deleted
# Results:
#   - SUCCESS
#   - FAILURE
####################################################
namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: stop_container
  inputs:
    - container_id
    - docker_options:
        required: false
    - docker_options_expression:
        default: docker_options + ' ' if bool(docker_options) else ''
        overridable: false
    - cmd_params:
        required: false
    - params: "cmd_params + ' ' if bool(cmd_params) else ''"
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - privateKeyFile:
        required: false
    - arguments:
        required: false
    - command:
        default: "'docker ' + docker_options_expression + 'stop ' + params + container_id"
        overridable: false
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
    - delete_container:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - privateKeyFile
            - command
            - arguments
            - characterSet
            - pty
            - timeout
            - closeSession
            - agentForwarding
        publish:
          - result: returnResult.replace("\n","")
          - standard_out
          - standard_err
          - exception
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE

  outputs:
    - result

  results:
    - SUCCESS
    - FAILURE