# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Restarts a remote Linux host using SSH.
#! @input host: hostname or IP address
#! @input port: optional - port number for running the command - Default: '22'
#! @input username: username to connect as
#! @input password: password of user
#! @input timeout: time in minutes to postpone restart
#! @input sudo_user: optional - whether to use 'sudo' prefix before command - Default: false
#! @input private_key_file: the absolute path to the private key file
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
#! @result SUCCESS: Linux host is restarted successfully
#! @result FAILURE: Linux host cannot be restarted due to an error
#!!#
####################################################
namespace: io.cloudslang.base.os.linux

imports:
  ssh_command: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: restart_server
  inputs:
    - host
    - port:
        default: '22'
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - timeout: 'now'
    - sudo_user:
        default: false
        required: false
    - private_key_file:
        required: false

  workflow:
    - server_restart:
        do:
          ssh_command.ssh_flow:
            - host
            - port
            - sudo_command: ${ 'echo ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - command: ${ sudo_command + ' shutdown -r ' + timeout }
            - username
            - password
            - private_key_file
        publish:
          - return_result
          - standard_out
          - standard_err
          - exception
          - command_return_code
          - return_code

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ standard_err }
            - string_to_find: 'shutdown'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: SUCCESS

  outputs:
    - return_result
    - standard_out
    - standard_err
    - exception
    - command_return_code
    - return_code
