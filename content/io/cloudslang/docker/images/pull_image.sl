#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Pulls a Docker image.
#
# Inputs:
#   - image_name - image name to be pulled
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file
#   - arguments - optional - arguments to pass to the command
#   - characterSet - optional - character encoding used for input stream encoding from target machine; Valid: SJIS, EUC-JP, UTF-8
#   - pty - whether to use PTY - Valid: true, false
#   - timeout - time in milliseconds to wait for command to complete - Default: 30000000
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false
# Outputs:
#   - return_result - response of the operation
#   - error_message - error message
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: io.cloudslang.docker.images

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: pull_image
  inputs:
    - image_name
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
    - characterSet:
        required: false
    - pty:
        required: false
    - timeout:
        default: "'30000000'"
        required: false
    - closeSession:
        required: false
    - agentForwarding:
        required: false
  workflow:
    - pull_image:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - privateKeyFile:
                required: false
            - command: "'docker pull ' + image_name"
            - arguments:
                required: false
            - characterSet:
                required: false
            - pty:
                required: false
            - timeout
            - closeSession:
                required: false
            - agentForwarding:
                required: false
        publish:
            - return_result: returnResult
            - error_message: standard_err
