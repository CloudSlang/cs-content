#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Executes a no-op SSH command.
#! @input host: Docker machine host
#! @input port: optional - SSH port - Default: '22'
#! @input username: Docker machine username
#! @input password: optional - Docker machine password
#! @input private_key_file: optional - absolute path to private key file
#! @input arguments: optional - arguments to pass to the command
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8' - Default: 'UTF-8'
#! @input pty: optional - whether to use PTY - Valid: true, false - Default: false
#! @input timeout: time in milliseconds to wait for command to complete - Default: '30000000'
#! @input close_session: optional - if 'false' the SSH session will be cached for future calls of this operation during the
#!                       life of the flow, if 'true' the SSH session used by this operation will be closed
#!                       Valid: true, false - Default: false
#! @input agent_forwarding: optional - the sessionObject that holds the connection if the close session is false
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: "0" if successful, "-1" otherwise
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: exception in case of failure
#! @output exit_status: return code of the remote command
#! @result SUCCESS: command execution finished successfully
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.os.linux

operation:
  name: validate_linux_machine_ssh_access
  inputs:
    - host
    - port:
        default: '22'
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - privateKeyFile:
        default: ${get("private_key_file", "")}
        required: false
        private: true
    - command:
        default: ':'
        private: true
    - arguments:
        required: false
    - character_set:
        required: false
    - characterSet:
        default: ${get("character_set", "UTF-8")}
        private: true
    - pty: 'false'
    - timeout: '30000000'
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
    - standard_out: ${ get('STDOUT', '') }
    - standard_err: ${ get('STDERR', '') }
    - exception: ${ get('exception', '') }
    - exit_status: ${ get('exitStatus', '') }
  results:
    - SUCCESS : ${ returnCode == '0' and (not 'Error' in STDERR) }
    - FAILURE
