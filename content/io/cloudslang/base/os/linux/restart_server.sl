# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow restart remote Linux host using ssh
#
#   Inputs:
#       - host - hostname or IP address
#       - port - optional - port number for running the command - Default: 22
#       - username - username to connect as
#       - password - password of user
#       - timeout - time (in minutes) to postpone restart
#       - privateKeyFile - the absolute path to the private key file
#       - sudo_user - use 'sudo' prefix before command
#
# Results:
#  SUCCESS: Linux host is restarted successfully
#  FAILURE: Linux host cannot be restarted due to an error
#
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
        required: False
    - username
    - password:
        required: false
    - timeout:
        default: "'now'"
    - sudo_user:
        default: False
        required: False
    - privateKeyFile:
        required: false
  
  workflow:
    - server_restart:
        do:
          ssh_command.ssh_flow:
            - host
            - port:
                required: False
            - sudo_command: "'echo ' + password + ' | sudo -S ' if bool(sudo_user) else ''"
            - command: "sudo_command + ' shutdown -r ' + timeout"
            - username
            - password:
                required: false
            - privateKeyFile:
                required: false
        publish: 
          - standard_err
          - standard_out
          - return_result: returnResult

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: standard_err
            - string_to_find: "'shutdown'"
        navigate:
          SUCCESS: FAILURE
          FAILURE: SUCCESS

  outputs:
    - standard_err
    - standard_out
    - return_result
