# (c) Copyright 2015 Liran Tal
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Performs a git push command to send a branch to a remote git repository.
#
# Inputs:
#   - host - hostname or IP address
#   - port - optional - port number for running the command
#   - username - username to connect as
#   - password - optional - password of user
#   - git_repository_localdir - optional - target directory where a git repository exists - Default: /tmp/repo.git
#   - git_push_branch - optional - branch to push - Default: master
#   - git_push_remote - optional - remote to push to - Default: origin
#   - sudo_user - true or false, whether the command should execute using sudo - Default: false
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
  name: git_push

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - git_repository_localdir: "/tmp/repo.git"
    - git_push_branch: "master"
    - git_push_remote: "origin"
    - sudo_user:
        default: false
        required: false
    - private_key_file:
        required: false

  workflow:
    - git_push:
        do:
          ssh.ssh_flow:
            - host
            - port
            - sudo_command: ${ 'echo ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - git_push: ${ ' && git push ' + git_push_remote + ' ' + git_push_branch }
            - command: ${ sudo_command + 'cd ' + git_repository_localdir + git_push + ' && echo GIT_SUCCESS' }
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
