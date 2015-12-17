# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Restarts a remote Linux service using SSH.
#
# Inputs:
#   - host - hostname or IP address
#   - port - optional - port number
#   - username - username to connect as
#   - password - optional - password of user
#   - service_name - Linux service name to be restarted
#   - sudo_user - optional - whether to use 'sudo' prefix before command - Default: false
#   - privateKeyFile - the absolute path to the private key file
# Outputs:
#   - standard_err - STDERR of the machine in case of successful request, null otherwise
#   - standard_out - STDOUT of the machine in case of successful request, null otherwise
#   - return_result - STDOUT of the remote machine in case of success or the cause of the error in case of exception
# Results:
#  SUCCESS: service was restarted successfully
#  FAILURE: service could not be restarted due to an error
#
####################################################
namespace: io.cloudslang.base.os.linux

imports:
  ssh_command: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: restart_service

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - service_name
    - sudo_user:
        default: false
        required: false
    - privateKeyFile:
        required: false

  workflow:
    - service_restart:
        do:
          ssh_command.ssh_flow:
            - host
            - port
            - sudo_command: ${ 'echo -e ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - command: ${ sudo_command + 'service ' + service_name + ' restart' + ' && echo CMD_SUCCESS' }
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
            - string_in_which_to_search: ${ standard_out }
            - string_to_find: 'CMD_SUCCESS'
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE

  outputs:
    - standard_err
    - standard_out
    - return_result
