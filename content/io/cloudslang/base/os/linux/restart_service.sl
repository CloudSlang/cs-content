# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow restart remote Linux service thrue ssh
#
#   Inputs:
#       - host - hostname or IP address
#       - username - username to connect as
#       - password - password of user
#       - service_name - linux service name to be restarted
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
    - username
    - password
    - service_name
    - privateKeyFile:
          required: false
  
  workflow:
    - service_restart:
        do:
          ssh_command.ssh_command:
            - host
            - command: >
                "service " + service_name + " restart"
            - username
            - password
            - privateKeyFile:
                  required: false

        publish: 
          - STDERR: standard_err
        navigate:
          SUCCESS: check_result
          FAILURE: FAILURE
    
    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: STDERR
            - string_to_find: service_name
        navigate:
          SUCCESS: FAILURE
          FAILURE: SUCCESS