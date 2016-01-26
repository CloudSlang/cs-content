# (c) Copyright 2015 Liran Tal
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Fetches a git branch.
#
# Inputs:
#   - host - hostname or IP address
#   - port - optional - port number for running the command
#   - username - username to connect as
#   - password - optional - password of user
#   - git_repository_localdir - optional - target directory where a git repository exists
#                             - Default: /tmp/repo.git
#   - git_fetch_remote - optional - remote repository to fetch from - Default: origin
#   - sudo_user - optional - true or false, whether the command should execute using sudo - Default: false
#   - private_key_file - optional - relative or absolute path to private key file
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
  name: git_fetch

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - git_repository_localdir:
        default: "/tmp/repo.git"
        required: true
    - git_fetch_remote:
        default: "origin"
        required: false
    - sudo_user:
        default: false
        required: false
    - private_key_file:
        required: false

  workflow:
    - git_fetch:
        do:
          ssh.ssh_flow:
            - host
            - port
            - sudo_command: ${ 'echo ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - git_fetch: ${ ' && git fetch ' + git_fetch_remote }
            - command: ${ sudo_command + 'cd ' + git_repository_localdir + git_fetch + ' && echo GIT_SUCCESS' }
            - username
            - password
            - privateKeyFile: ${ private_key_file }
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
