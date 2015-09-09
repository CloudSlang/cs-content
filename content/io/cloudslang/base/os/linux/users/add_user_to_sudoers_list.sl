# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs a linux command to add a specified user to sudoers group
#
#    Inputs:
#      - host - hostname or IP address
#      - port - optional - port number for running the command
#      - username - username to connect as
#      - password - optional - password of user
#      - sudo_user - optional- true or false, whether the command should execute using sudo - Default: false
#      - private_key_file - optional - the path to the private key file
#      - user: - the user to be added in sudoers group
#
# Results:
#  SUCCESS: the user was successfully added
#  FAILURE: an error occurred when trying to add user
#
####################################################
namespace: io.cloudslang.base.os.linux.users

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: add_user_to_sudoers_list

  inputs:
      - host
      - port:
          required: false
      - username
      - password
      - sudo_user:
          default: false
          required: false
      - private_key_file:
          required: false
      - user:
          required: true

  workflow:
      - add_user:
          do:
            ssh.ssh_flow:
              - host
              - port:
                  required: false
              - username:
                  default: "'root'"
                  overridable: false
              - password:
                  required: true
              - private_key_file:
                  required: false
              - user:
                  required: true
              - command: "'echo \"' + user + ' ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers'"

          publish:
            - standard_err
            - standard_out
            - command
            - command_return_code

      - check_result:
          do:
            strings.string_occurrence_counter:
              - string_in_which_to_search: command_return_code
              - string_to_find: "'0'"