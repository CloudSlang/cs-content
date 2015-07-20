#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
###############################################################################################################################################################################
#  Runs an SSH command on the host.
#
#  Inputs:
#    - host - hostname or IP address
#    - port - optional - port number for running the command - Default: 22
#    - command - command to execute
#    - pty - optional - whether to use pty - Valid: true, false - Default: false
#    - username - username to connect as
#    - password - optional - password of user
#    - arguments - optional - arguments to pass to the command
#    - privateKeyFile - optional - path to the private key file
#    - timeout - optional - time in milliseconds to wait for the command to complete - Default: 90000 ms
#    - characterSet - optional - character encoding used for input stream encoding from the target machine - Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#    - closeSession - optional - if false the ssh session will be cached for future calls of this operation during the life of the flow, if true the ssh session used by this operation will be closed - Valid: true, false - Default: false
#    - agentForwarding - optional - the sessionObject that holds the connection if the close session is false
# Outputs:
#    - returnResult - STDOUT of the remote machine in case of success or the cause of the error in case of exception
#    - return_code - return code of the command
#    - standard_out - STDOUT of the machine in case of successful request, null otherwise
#    - standard_err - STDERR of the machine in case of successful request, null otherwise
#    - exception - contains the stack trace in case of an exception
#    - exitStatus - The exit status of the remote command corresponding to the SSH channel. The exit status is only available for certain types of channels, and only after the channel was closed (more exactly, just before the channel is closed).
#	Examples: 0 for a successful command, -1 if the command was not yet terminated (or this channel type has no command), 126 if the command cannot execute.
# Results:
#    - SUCCESS - SSH access was successful and returned with code 0
#    - FAILURE - otherwise
###############################################################################################################################################################################

namespace: io.cloudslang.base.remote_command_execution.ssh

operation:
    name: ssh_command
    inputs:
      - host
      - port: "'22'"
      - command
      - pty: "'false'"
      - username
      - password:
          required: false
      - arguments:
          required: false
      - privateKeyFile:
          required: false
      - timeout: "'90000'"
      - characterSet: "'UTF-8'"
      - closeSession: "'false'"
      - agentForwarding:
          required: false
    action:
      java_action:
        className: io.cloudslang.content.ssh.actions.SSHShellCommandAction
        methodName: runSshShellCommand
    outputs:
      - returnResult
      - return_code: returnCode
      - standard_out: "'' if 'STDOUT' not in locals() else STDOUT"
      - standard_err: "'' if 'STDERR' not in locals() else STDERR"
      - exception: "'' if 'exception' not in locals() else exception"
      - exitStatus: "'' if 'exitStatus' not in locals() else exitStatus"
    results:
      - SUCCESS: returnCode == '0' and (not 'Error' in STDERR)
      - FAILURE