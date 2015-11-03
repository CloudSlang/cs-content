#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
###############################################################################################################################################################################
#  Validates SSH access to the host and then runs an SSH command on the host.
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
#    - standard_out - STDOUT of the machine in case of successful request, null otherwise
#    - standard_err - STDERR of the machine in case of successful request, null otherwise
#    - exception - contains the stack trace in case of an exception
#    - command_return_code - The return code of the remote command corresponding to the SSH channel. The return code is only available for certain types of channels, and only after the channel was closed (more exactly, just before the channel is closed).
#	            Examples: 0 for a successful command, -1 if the command was not yet terminated (or this channel type has no command), 126 if the command cannot execute.
# Results:
#    - SUCCESS - SSH access was successful and returned with code 0
#    - FAILURE - otherwise
###############################################################################################################################################################################

namespace: io.cloudslang.base.remote_command_execution.ssh

imports:
  linux: io.cloudslang.base.os.linux
  utils: io.cloudslang.base.utils

flow:
    name: ssh_flow
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
    workflow:
      - validate_ssh_access:
          do:
            linux.validate_linux_machine_ssh_access:
              - host
              - port
              - username
              - password
              - privateKeyFile
              - arguments
              - characterSet
              - pty
              - timeout
              - closeSession
              - agentForwarding
          publish:
            - return_result
            - return_code
            - standard_out
            - standard_err
            - exception
            - exit_status
          navigate:
            SUCCESS: ssh_command
            FAILURE: check_ssh_unstable_session_in_validation

      - ssh_command:
          do:
            ssh_command:
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
            - return_result: returnResult
            - return_code
            - standard_out
            - standard_err
            - exception
            - exit_status: command_return_code
          navigate:
            SUCCESS: SUCCESS
            FAILURE: check_ssh_unstable_session_in_command_execution

      - check_ssh_unstable_session_in_validation: # TODO: timeout
          do:
            utils.check_ssh_unstable_session:
              - return_result
              - return_code
              - standard_out
              - standard_err
              - exit_status
          navigate:
            SESSION_IS_DOWN: ssh_command
            FAILURE_WITH_NO_MESSAGE: validate_ssh_access
            NO_ISSUE_FOUND: FAILURE # todo: custom result

      - check_ssh_unstable_session_in_command_execution: # TODO: timeout
          do:
            utils.check_ssh_unstable_session:
              - return_result
              - return_code
              - standard_out
              - standard_err
              - exit_status
          navigate:
            SESSION_IS_DOWN: ssh_command
            FAILURE_WITH_NO_MESSAGE: ssh_command
            NO_ISSUE_FOUND: FAILURE
    outputs:
      - returnResult: return_result
      - return_code
      - standard_out
      - standard_err
      - exception
      - command_return_code: exit_status
    results:
      - SUCCESS
      - FAILURE
