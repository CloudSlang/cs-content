# (c) Copyright 2015 Liran Tal
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow merges a git branch to another branch
#
#   Inputs:
#       - host - hostname or IP address
#       - port - optional - port number for running the command
#       - username - username to connect as
#       - password - optional - password of user
#       - git_repository_localdir - the target directory where a git repository exists and git_branch should be checked out to
#                                 - Default: /tmp/repo.git
#       - git_merge_branch - specify the branch to merge from
#       - sudo_user - optional - true or false, whether the command should execute using sudo
#       - private_key_file - relative or absolute path to the private key file
#
# Results:
#  SUCCESS: git repository successfully merged
#  FAILURE: an error when trying to merge a git branch
#
####################################################
namespace: io.cloudslang.git

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: git_merge

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
    - git_merge_branch:
        required: true
    - sudo_user:
        default: false
        required: false
    - private_key_file:
        required: false

  workflow:
    - git_merge:
        do:
          ssh.ssh_flow:
            - host
            - port
            - sudo_command: ${ 'echo ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - git_merge: ${ ' && git merge ' + git_merge_branch }
            - command: ${ sudo_command + 'cd ' + git_repository_localdir + git_merge + ' && echo GIT_SUCCESS' }
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
