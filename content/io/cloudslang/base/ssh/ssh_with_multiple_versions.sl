#   (c) Copyright 2014-2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Runs an SSH command on the host with multple action versions.
#!
#! @input host: hostname or IP address
#! @input port: optional - port number for running the command - Default: '22'
#! @input command: command to execute
#! @input username: username to connect as
#! @input password: optional - password of user
#! @input timeout: optional - time in milliseconds to wait for the command to complete - Default: 90000
#!
#! @output version_1: version 1 of the command
#! @output version_2: version 2 of the command
#! @output ssh_result_1: version 1 of the command
#! @output ssh_result_2: version 2 of the command
#!
#! @result SUCCESS: SSH access was successful and returned with code '0'
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.ssh

imports:
  ssh: io.cloudslang.base.ssh
  print: io.cloudslang.base.print

flow:
  name: ssh_with_multiple_versions

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - command
    - timeout:
        required: false

  workflow:
    - ssh_version_one:
        do:
          ssh.ssh_command_v_0_1_0:
            - host
            - port
            - username
            - password
            - command
            - timeout
        publish:
          - version_1: ${version}
          - ssh_result_1: ${return_result}

    - ssh_version_two:
        do:
          ssh.ssh_command_v_0_2_0:
            - host
            - port
            - username
            - password
            - command
            - timeout
        publish:
          - version_2: ${version}
          - ssh_result_2: ${return_result}

    - print_results:
        do:
          print.print_text:
            - text: >-
                ${
                'SSH call one - version[' + version_1 + '] - message[' + ssh_result_1 + '],
                \nSSH call two - version[' + version_2 + '] - message[' + ssh_result_2 + ']'
                }
        navigate:
          - SUCCESS: SUCCESS

  outputs:
    - version_1
    - version_2
    - ssh_result_1
    - ssh_result_2

  results:
    - SUCCESS
    - FAILURE
