#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Validates SSH access to the host and then runs an SSH command on the host.
#! @input host: hostname or IP address
#! @input port: optional - port number for running the command - Default: '22'
#! @input command: command to execute
#! @input pty: optional - whether to use PTY - Valid: true, false - Default: false
#! @input username: username to connect as
#! @input password: optional - password of user
#! @input arguments: optional - arguments to pass to the command
#! @input private_key_file: optional - path to the private key file
#! @input timeout: optional - time in milliseconds to wait for the command to complete - Default: 90000
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input close_session: optional - if 'false' the SSH session will be cached for future calls of this operation during the
#!                       life of the flow, if 'true' the SSH session used by this operation will be closed
#!                       Valid: true, false - Default: false
#! @input agent_forwarding: optional - the sessionObject that holds the connection if the close session is false
#! @input smart_recovery: whether the flow should try to recover in case of SSH session failure
#!                        such failure may happen because of unstable ssh connection - e.g. 'Session is down' exception
#!                        Default: true
#! @input retries: limit of reconnect tries - Default: 5
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: '0' for a successful command, '-1' if the command was not yet terminated (or this
#!                              channel type has no command), '126' if the command cannot execute.
#! @output return_code: return code of the command
#! @result SUCCESS: SSH access was successful and returned with code '0'
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.ssh

imports:
  linux: io.cloudslang.base.os.linux
  utils: io.cloudslang.base.utils
  ssh: io.cloudslang.base.ssh

flow:
    name: ssh_flow
    inputs:
      - host
      - port: '22'
      - command
      - pty: 'false'
      - username
      - password:
          required: false
          sensitive: true
      - arguments:
          required: false
      - private_key_file:
          required: false
      - privateKeyFile:
          default: ${get("private_key_file", "")}
          required: false
          private: true
      - timeout: '90000'
      - character_set:
          required: false
      - characterSet:
          default: ${get("character_set", "UTF-8")}
          private: true
      - close_session:
          required: false
      - closeSession:
          default: ${get("close_session", "false")}
          private: true
      - agent_forwarding:
          required: false
      - agentForwarding:
          default: ${get("agent_forwarding", "")}
          required: false
          private: true
      - smart_recovery: True
      - retries: 5
    workflow:
      - validate_ssh_access:
          do:
            linux.validate_linux_machine_ssh_access:
              - host
              - port
              - username
              - password
              - private_key_file
              - arguments
              - character_set
              - pty
              - timeout
              - close_session
              - agent_forwarding
          publish:
            - return_result
            - return_code
            - standard_out
            - standard_err
            - exception
            - exit_status
          navigate:
            - SUCCESS: ssh_command
            - FAILURE: handle_ssh_session_recovery

      - ssh_command:
          do:
            ssh.ssh_command:
              - host
              - port
              - username
              - password
              - private_key_file
              - command
              - arguments
              - character_set
              - pty
              - timeout
              - close_session
              - agent_forwarding
          publish:
            - return_result
            - standard_out
            - standard_err
            - return_code
            - exception
            - exit_status: ${ command_return_code }
          navigate:
            - SUCCESS: SUCCESS
            - FAILURE: handle_ssh_session_recovery

      - handle_ssh_session_recovery:
          do:
            utils.handle_session_recovery:
              - enabled: ${ smart_recovery }
              - retries
              - return_result
              - return_code
              - exit_status
          publish:
            - retries: ${updated_retries}
          navigate:
            - RECOVERY_DISABLED: FAILURE
            - TIMEOUT: FAILURE
            - SESSION_IS_DOWN: validate_ssh_access
            - FAILURE_WITH_NO_MESSAGE: validate_ssh_access
            - CUSTOM_FAILURE: validate_ssh_access
            - NO_ISSUE_FOUND: FAILURE
    outputs:
      - return_result
      - standard_out
      - standard_err
      - exception
      - command_return_code: ${ exit_status }
      - return_code
    results:
      - SUCCESS
      - FAILURE
