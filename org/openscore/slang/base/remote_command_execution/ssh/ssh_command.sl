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
#    - host - Hostname or ip address.
#    - port - The port number for running the command.
#    - command - The command to execute.
#    - pty - Whether to use pty - valid values: true, false. Default value: false.
#    - username - Username to connect as.
#    - password - Password of user.
#    - arguments - The arguments to pass to the command.
#    - privateKeyFile - The absolute path to the private key file.
#    - timeout - Time in milliseconds to wait for the command to complete. Default value: 90000 ms.
#    - characterSet - The character encoding used for input stream encoding from the target machine. Valid values: SJIS, EUC-JP, UTF-8. Default value: UTF-8.
#    - closeSession - If false the ssh session will be cached for future calls of this operation during the life of the flow.
#      If true the ssh session used by this operation will be closed. Valid values: true, false. Default value: true.
# Outputs:
#    - returnResult - Contains the STDOUT of the remote machine in case of success or the cause of the error in case of exception
#    - STDOUT - Contains the standard Output of the machine in case of successful request, null otherwise
#    - STDERR - Contains the standard Error of the machine in case of successful request, null otherwise
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
