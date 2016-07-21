#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
###############################################################################################################################################################################
#!!
#! @description: Runs an SSH command on the host.
#! @input host: hostname or IP address
#! @input port: optional - port number for running the command - Default: '22'
#! @input command: command to execute
#! @input pty: optional - whether to use PTY - Valid: true, false - Default: false
#! @input username: username to connect as
#! @input password: optional - password of user
#! @input arguments: optional - arguments to pass to the command
#! @input private_key_file: optional - absolute path to private key file - Default: none
#! @input timeout: optional - time in milliseconds to wait for the command to complete - Default: 90000
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8' - Default: 'UTF-8'
#! @input close_session: optional - if 'false' the SSH session will be cached for future calls of this operation during the
#!                       life of the flow, if 'true' the SSH session used by this operation will be closed
#!                       Valid: true, false - Default: false
#! @input agent_forwarding: optional - the sessionObject that holds the connection if the close session is false
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: return code of the command
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: '0' for a successful command, '-1' if the command was not yet terminated (or this
#!                              channel type has no command), '126' if the command cannot execute.
#! @result SUCCESS: SSH access was successful and returned with code '0'
#! @result FAILURE: otherwise
#!!#
###############################################################################################################################################################################

namespace: io.cloudslang.base.ssh

operation:
    name: ssh_command
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
    java_action:
      gav: 'io.cloudslang.content:cs-ssh:0.0.33'
      class_name: io.cloudslang.content.ssh.actions.SSHShellCommandAction
      method_name: runSshShellCommand
    outputs:
      - return_result: ${ get('returnResult', '') }
      - return_code: ${ returnCode }
      - standard_out: ${ '' if 'STDOUT' not in locals() else STDOUT }
      - standard_err: ${ '' if 'STDERR' not in locals() else STDERR }
      - exception: ${ '' if 'exception' not in locals() else exception }
      - command_return_code: ${ '' if 'exitStatus' not in locals() else exitStatus }
    results:
      - SUCCESS: ${ returnCode == '0' and (not 'Error' in STDERR) }
      - FAILURE
