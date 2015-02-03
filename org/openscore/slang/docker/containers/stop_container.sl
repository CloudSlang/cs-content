#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will stop a specified Docker container.
#
#   Inputs:
#       - containerID - ID of the container to be deleted
#       - cmdParams - optional - command parameters - Default: none
#       - host - Docker machine host
#       - port - optional - SSH port - Default: 22
#       - username - Docker machine username
#       - password - Docker machine password
#       - pty - whether to use pty; valid values: true, false; Default: false
#       - arguments - arguments to pass to the command; Default: none
#       - privateKeyFile - the absolute path to the private key file; Default: none
#       - timeout - time in milliseconds to wait for the command to complete; Default: 90000 ms
#       - characterSet - character encoding used for input stream encoding from the target machine; valid values: SJIS, EUC-JP, UTF-8; Default: UTF-8;
#       - closeSession - if false the ssh session will be cached for future calls of this operation during the life of the flow
#                        if true the ssh session used by this operation will be closed; Valid values: true, false; Default: false
#   Outputs:
#       - container_ID - ID of the container that was deleted
#       - error_message - error message
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################
namespace: org.openscore.slang.docker.containers

operation:
  name: stop_container
  inputs:
    - containerID
    - cmdParams:
        default: "''"
    - host
    - port:
        default: "'22'"
    - username
    - password
    - privateKeyFile:
        default: "''"
    - arguments:
        default: "''"
    - command:
        default: "'docker stop ' + cmdParams + ' ' + containerID"
        override: true
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
      className: org.openscore.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - container_ID: returnResult
    - error_message: STDERR if returnCode == '0' else returnResult
  results:
    - SUCCESS : returnCode == '0' and (not 'Error' in STDERR)
    - FAILURE