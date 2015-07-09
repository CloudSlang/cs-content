# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow restart remote Linux service using ssh
#
#   Inputs:
#       - host - hostname or IP address
#       - username - username to connect as
#       - password - password of user
#       - service_name - linux service name to be restarted
#       - sudo_user - optional - 'true' or 'false' whether to execute the command on behalf of username with sudo. Default: false
#       - privateKeyFile - optional - path to the private key file
#
# Results:
#  SUCCESS: service on Linux host is restarted successfully
#  FAILURE: service cannot be restarted due to an error
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
        required: False
    - service_name
    - sudo_user:
        default: False
        required: False
    - privateKeyFile:
        required: false
  
  workflow:
    - service_restart:
        do:
          ssh_command.ssh_flow:
            - host
            - port:
                required: false
            - sudo_command: "'echo -e ' + password + ' | sudo -S ' if bool(sudo_user) else ''"
            - command: "sudo_command + 'service ' + service_name + ' restart' + ' && echo CMD_SUCCESS'"
            - username
            - password:
                required: False
            - privateKeyFile:
                required: false

        publish: 
          - standard_err
          - standard_out
          - return_result: returnResult

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: standard_out
            - string_to_find: "'CMD_SUCCESS'"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE

  outputs:
    - standard_err
    - standard_out
    - return_result