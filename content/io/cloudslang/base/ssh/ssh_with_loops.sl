#   (c) Copyright 2014-2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Runs an SSH command on the host in a loop.
#!
#! @input host: hostname or IP address
#! @input port: optional - port number for running the command - Default: '22'
#! @input command: command to execute
#! @input username: username to connect as
#! @input password: optional - password of user
#! @input timeout: optional - time in milliseconds to wait for the command to complete - Default: 90000
#!
#! @output password_copy: copy of password input
#!
#! @result SUCCESS: SSH access was successful and returned with code '0'
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.ssh

imports:
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: ssh_with_loops

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
    - loop_type_decision:
        do:
          strings.string_equals:
            - first_string: ${get_sp('io.cloudslang.base.ssh.loop_type', "for loop")}
            - second_string: 'parallel loop'
        navigate:
          - SUCCESS: parallel_loop_ssh_calls
          - FAILURE: for_loop_ssh_calls

    - for_loop_ssh_calls:
        loop: # compare to step `parallel_loop_ssh_calls`
          for: i in 1,2,3
          do:
            ssh.ssh_with_multiple_versions:
              - host: ${host[:-1] + str(i)}
              - port
              - username
              - password
              - command
              - timeout
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

    - parallel_loop_ssh_calls:
        parallel_loop: # compare to step `for_loop_ssh_calls`
          for: i in 1,2,3
          do:
            ssh.ssh_with_multiple_versions:
              - host: ${host[:-1] + str(i)}
              - port
              - username
              - password
              - command
              - timeout

  outputs:
    - password_copy: ${password}

  results:
    - SUCCESS
    - FAILURE
