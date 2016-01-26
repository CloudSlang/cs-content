# (c) Copyright 2015 Liran Tal
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Checks out a git branch.
#
# Inputs:
#   - host - hostname or IP address
#   - port - optional - port number for running the command
#   - username - username to connect as
#   - password - optional - password of user
#   - git_branch - optional - git branch to checkout
#   - git_repository_localdir - optional - target directory where a git repository exists and git_branch should be checked out to - Default: /tmp/repo.git
#   - git_pull_remote - optional - if git_pull is set to true then specify the remote branch to pull from - Default: origin
#   - sudo_user - optional - true or false, whether the command should execute using sudo - Default: false
#   - private_key_file - optional - path to private key file
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
  name: git_checkout_branch

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - git_branch:
        required: true
    - git_repository_localdir: "/tmp/repo.git"
    - git_pull_remote:
        default: "origin"
        required: false
    - sudo_user:
        default: false
        required: false
    - private_key_file:
        required: false

  workflow:
    - git_clone:
        do:
          ssh.ssh_flow:
            - host
            - port
            - sudo_command: ${ 'echo ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - git_pull: ${ ' && git pull ' + git_pull_remote + ' ' + git_branch }
            - command: ${ sudo_command + 'cd ' + git_repository_localdir + ' && ' + ' git checkout ' + git_branch + ' ' + git_pull + ' && echo GIT_SUCCESS' }
            - username
            - password
            - private_key_file
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
