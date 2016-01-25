# (c) Copyright 2015 Liran Tal
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Performs a git reset on a git directory to clean it up.
#
# Inputs:
#   - host - hostname or IP address
#   - port - optional - port number for running the command
#   - username - username to connect as
#   - password - optional - password of user
#   - git_repository_localdir - target directory where a git repository exists - Default: /tmp/repo.git
#   - git_reset_target - optional - SHA you want to reset the branch to - Default: HEAD
#   - sudo_user - optional - true or false, whether the command should execute using sudo
#   - private_key_file - absolute path to the private key file
# Outputs:
#   - standard_err - STDERR of the machine in case of successful request, null otherwise
#   - standard_out - STDOUT of the machine in case of successful request, null otherwise
#   - command - git command
####################################################
namespace: io.cloudslang.git

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: git_reset

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - git_repository_localdir: "/tmp/repo.git"
    - git_reset_target:
        default: "HEAD"
        required: false
    - sudo_user:
        default: false
        required: false
    - private_key_file:
        required: false

  workflow:
    - git_reset:
        do:
          ssh.ssh_flow:
            - host
            - port
            - sudo_command: ${ 'echo ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - git_reset: ${ ' && git reset --hard ' + git_reset_target }
            - command: ${ sudo_command + ' cd ' + git_repository_localdir + git_reset + ' && echo GIT_SUCCESS' }
            - username
            - password
            - private_key_file
        publish:
          - standard_err
          - standard_out
          - command

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ standard_out }
            - string_to_find: "GIT_SUCCESS"

  outputs:
    - standard_err
    - standard_out
    - command
