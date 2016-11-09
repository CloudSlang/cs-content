
#   (c) Copyright 2014-2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Runs an SSH command on the host.
#!
#! @input host: hostname or IP address
#! @input port: optional - port number for running the command - Default: '22'
#! @input command: command to execute
#! @input username: username to connect as
#! @input password: optional - password of user
#! @input timeout: optional - time in milliseconds to wait for the command to complete - Default: 90000
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: return code of the command
#! @output version: version of the command
#!
#! @result SUCCESS: SSH access was successful and returned with code '0'
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.ssh

operation:
  name: ssh_command_v_0_2_0

  inputs:
    - host
    - port:
        default: '22'
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - command
    - timeout:
        default: '90000'
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-ssh:0.2.0'
    class_name: io.cloudslang.content.ssh.actions.SSHShellCommandAction
    method_name: runSshShellCommand

  outputs:
    - return_result: ${ get('returnResult', '') }
    - return_code: ${ returnCode }
    - version

  results:
    - SUCCESS: ${ returnCode == '0' }
    - FAILURE
