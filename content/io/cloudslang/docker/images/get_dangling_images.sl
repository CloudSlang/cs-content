#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves a list of all the dangling Docker images.
#
# Inputs:
#   - host - Docker machine host
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - path to the private key file - Default: none
#   - arguments - optional - arguments to pass to the command - Default: none
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false - Default: false
#   - timeout - optional - time in milliseconds to wait for command to complete - Default: 30000000
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false - Default: false
# Outputs:
#   - dangling_image_list - list of IDs of dangling Docker images
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: io.cloudslang.docker.images

operation:
  name: get_dangling_images
  inputs:
    - host
    - port: "'22'"
    - username
    - password
    - privateKeyFile: "''"
    - command: >
        "docker images -f \"dangling=true\" -q"
    - arguments: "''"
    - characterSet: "'UTF-8'"
    - pty: "'false'"
    - timeout: "'30000000'"
    - closeSession: "'false'"
  action:
    java_action:
      className: io.cloudslang.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - dangling_image_list: returnResult
  results:
    - SUCCESS: returnCode == '0' and (not 'Error' in STDERR)
    - FAILURE