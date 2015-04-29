#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates a Docker container.
#
# Inputs:
#   - imageID - Docker image that will be assigned to the container
#   - containerName - container name
#   - cmdParams - optional - command parameters
#   - containerCmd - optional - container command
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

operation:
  name: create_container
  inputs:
    - imageID
    - containerName
    - cmdParams:
        default: "''"
        required: false
    - containerCmd:
        default: "''"
        required: false
    - host
    - port:
        default: "'22'"
    - username
    - password
    - privateKeyFile:
        default: "''"
    - command:
        default: "'docker run -d --name ' + containerName + ' ' + cmdParams + ' ' + imageID + ' ' + containerCmd"
        overridable: false
    - arguments:
        default: "''"
    - characterSet:
        default: "'UTF-8'"
    - pty:
        default: "'false'"
    - timeout:
        default: "'90000'"
    - closeSession:
        default: "'false'"
  action:
    java_action:
      className: io.cloudslang.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - db_container_ID: returnResult
    - error_message: "'' if 'STDERR' not in locals() else STDERR if returnCode == '0' else returnResult"
  results:
    - SUCCESS : returnCode == '0' and (not 'Error' in STDERR)
    - FAILURE