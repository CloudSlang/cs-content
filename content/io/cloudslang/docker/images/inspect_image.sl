#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Inspects Docker image.
#
# Inputs:
#   - imageID - ID of the image to be inspected
#   - host - Docker machine host
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file - Default: none
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false - Default: false
#   - timeout - optional - time in milliseconds to wait for command to complete - Default: 90000
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false - Default: false
# Outputs:
#   - standard_out - STDOUT of the machine in case of successful request, null otherwise
#   - standard_err - STDERR of the machine in case of successful request, null otherwise
# Results:
#   - SUCCESS
#   - FAILURE
####################################################
namespace: io.cloudslang.docker.images

operation:
  name: inspect_image
  inputs:
    - imageName
    - host
    - port:
        default: "'22'"
    - username
    - password
    - privateKeyFile:
        default: "''"
    - command:
        default: "'docker inspect ' + imageName"
        overridable: false
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
     - standard_out: "'' if 'STDOUT' not in locals() else STDOUT"
     - standard_err: "'' if 'STDERR' not in locals() else STDERR"
  results:
    - SUCCESS : returnCode == '0' and (not 'Error' in STDERR)
    - FAILURE
