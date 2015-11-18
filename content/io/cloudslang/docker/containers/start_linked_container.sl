#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Start a linked container.
#
# Inputs:
#   - dbContainerIp - IP of a container that contains MySQL
#   - dbContainerName - name of the container that contains MySQL
#   - imageName - image name
#   - containerName - linked container name
#   - linkParams - link parameters
#   - cmdParams - command Parameters
#   - container_cmd - optional - command to be executed in the container
#   - host - Docker machine host
#   - port - optional - SSH port - Default: '22'
#   - username: Docker machine username
#   - password - optional - Docker machine password
#   - privateKeyFile - optional - path to private key file
#   - arguments - optional - arguments to pass to command - Default: none
#   - characterSet - optional - character encoding used for input stream encoding from target machine
#                             - Valid: SJIS, EUC-JP, UTF-8
#                             - Default: UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false - Default: false
#   - timeout - optional - time in milliseconds to wait for command to complete - Default: '90000'
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow,
#                               if true the SSH session used will be closed;
#                             - Valid: true, false
#                             - Default: false
# Outputs:
#   - container_id - ID of the container that was started.
#   - error_message - error message
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: start_linked_container
  inputs:
    - dbContainerIp
    - dbContainerName
    - imageName
    - containerName
    - linkParams
    - cmdParams
    - container_cmd:
        required: false
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
        required: false
    - closeSession:
        required: false
    - container_cmd_expression:
        default: ${' ' + container_cmd if container_cmd else ''}
        overridable: false
    - command:
        default: >
          ${'docker run --name ' + containerName + ' --link ' + linkParams + ' ' + cmdParams +
          ' -d ' + imageName + container_cmd_expression}
        overridable: false

  workflow:
    - start_linked_container:
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
        publish:
          - returnResult
          - standard_err
          - return_code
  outputs:
    - container_id: ${returnResult}
    - error_message: ${standard_err if(return_code == '0' and standard_err != '') else returnResult}