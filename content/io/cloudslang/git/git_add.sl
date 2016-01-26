# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Performs a git command to add files as staged files for a later local commit.
#
# Inputs:
#   - host - hostname or IP address
#   - port - optional - port number for running the command
#   - username - username to connect as
#   - password - optional - password of user
#   - sudo_user - optional- true or false, whether the command should execute using sudo - Default: false
#   - private_key_file - optional - path to private key file
#   - git_repository_localdir - target directory where a git repository exists - Default: /tmp/repo.git
#   - git_add_files - optional - files to add/stage - Default: "*"
# Outputs:
#   - standard_err - STDERR of the machine in case of successful request, null otherwise
#   - standard_out - STDOUT of the machine in case of successful request, null otherwise
#   - return_code - return code of the command
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
      - git_repository_localdir: "/tmp/repo.git"
      - git_add_files:
          default: "*"
          required: false

  workflow:
      - git_add:
          do:
            ssh.ssh_flow:
              - host
              - port
              - username
              - password
              - privateKeyFile: ${ private_key_file }
              - git_add: ${ ' git add ' + git_add_files }
              - command: ${ 'cd ' + git_repository_localdir + ' && ' + git_add + ' && echo GIT_SUCCESS' }

          publish:
            - standard_err
            - standard_out
            - return_code

      - check_result:
          do:
            strings.string_occurrence_counter:
              - string_in_which_to_search: ${ standard_out }
              - string_to_find: "GIT_SUCCESS"

  outputs:
    - standard_err
    - standard_out
    - return_code
