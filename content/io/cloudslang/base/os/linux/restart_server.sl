# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Restart remote Linux host using SSH.
#
# Inputs:
#   - host - hostname or IP address
#   - port - optional - port number for running the command - Default: 22
#   - username - username to connect as
#   - password - optional - password of user
#   - timeout - time in minutes to postpone restart
#   - sudo_user - optional - whether to use 'sudo' prefix before command - Default: false
#   - privateKeyFile - the absolute path to the private key file
# Outputs:
#   - standard_err - STDERR of the machine in case of successful request, null otherwise
#   - standard_out - STDOUT of the machine in case of successful request, null otherwise
#   - return_result - STDOUT of the remote machine in case of success or the cause of the error in case of exception
# Results:
#  SUCCESS: Linux host restarted successfully
#  FAILURE: Linux host was not restarted due to an error
####################################################
namespace: io.cloudslang.base.os.linux

imports:
  ssh_command: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: restart_server

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - timeout:
        default: 'now'
    - sudo_user:
        default: false
        required: false
    - privateKeyFile:
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
            - privateKeyFile
        publish:
          - standard_err
          - standard_out
          - return_result: ${ returnResult }

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ standard_err }
            - string_to_find: 'shutdown'
        navigate:
          SUCCESS: FAILURE
          FAILURE: SUCCESS

  outputs:
    - standard_err
    - standard_out
    - return_result
