# (c) Copyright 2015 Tusa Mihai
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs a git command to add files as staged files for a later local commit
#
#    Inputs:
#      - host - hostname or IP address
#      - port - optional - port number for running the command
#      - username - username to connect as
#      - password - optional - password of user
#      - sudo_user - optional- true or false, whether the command should execute using sudo - Default: false
#      - private_key_file - optional - the path to the private key file
#      - git_repository_localdir - the target directory where a git repository exists - Default: /tmp/repo.git
#      - git_add_files - optional - the files that has to be added/staged - Default: "'*'"
#
# Results:
#  SUCCESS: the files was successfully added
#  FAILURE: an error when trying to add files
#
####################################################
namespace: io.cloudslang.git

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: git_add

  inputs:
      - host
      - port:
          required: false
      - username
      - password:
          required: false
      - sudo_user:
          default: false
          required: false
      - private_key_file:
          required: false
      - git_repository_localdir:
          default: "'/tmp/repo.git'"
          required: true
      - git_add_files:
          default: "'*'"
          required: false

  workflow:
      - git_add:
          do:
            ssh.ssh_flow:
              - host
              - port:
                  required: false
              - username
              - password:
                  required: false
              - private_key_file:
                  required: false
              - git_add: "' git add ' + git_add_files"
              - command: "'cd ' + git_repository_localdir + ' && ' + git_add + ' && echo GIT_SUCCESS'"

          publish:
            - standard_err
            - standard_out
            - command

      - check_result:
          do:
            strings.string_occurrence_counter:
              - string_in_which_to_search: standard_out
              - string_to_find: "'GIT_SUCCESS'"

  outputs:
    - standard_err
    - standard_out
    - command