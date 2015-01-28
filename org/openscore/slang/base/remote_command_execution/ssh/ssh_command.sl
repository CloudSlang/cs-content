#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

###############################################################################################################################################################################
# Runs an SSH command on the host.
#
# Inputs:
#    - host - hostname or IP address
#    - port - port number for running the command
#    - command - command to execute
#    - pty - whether to use pty; valid values: true, false; Default: false
#    - username - username to connect as
#    - password - password of user
#    - arguments - arguments to pass to the command
#    - privateKeyFile - the absolute path to the private key file
#    - timeout - time in milliseconds to wait for the command to complete; Default: 90000 ms
#    - characterSet - character encoding used for input stream encoding from the target machine; valid values: SJIS, EUC-JP, UTF-8; Default: UTF-8;
#    - closeSession - if false the ssh session will be cached for future calls of this operation during the life of the flow
#                     if true the ssh session used by this operation will be closed; Valid values: true, false; Default: true
# Outputs:
#    - returnResult - contains the STDOUT of the remote machine in case of success or the cause of the error in case of exception
#    - STDOUT - contains the standard Output of the machine in case of successful request, null otherwise
#    - STDERR - contains the standard Error of the machine in case of successful request, null otherwise
# Results:
#    - SUCCESS
#    - FAILURE
###############################################################################################################################################################################

namespace: org.openscore.slang.base.remote_command_execution.ssh

operations:
  - ssh_command:
        inputs:
          - host
          - port
          - command
          - pty:
                default: "'false'"
          - username
          - password
          - arguments:
                required: false
          - privateKeyFile:
                required: false
          - timeout:
                default: "'90000'"
          - characterSet:
                default: "'UTF-8'"
          - closeSession:
                default: "'true'"
        action:
          java_action:
            className: org.openscore.content.ssh.actions.SSHShellCommandAction
            methodName: runSshShellCommand
        outputs:
          - returnResult
          - STDOUT
          - STDERR
        results:
          - SUCCESS
          - FAILURE
