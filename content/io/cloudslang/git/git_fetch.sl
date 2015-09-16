# (c) Copyright 2015 Liran Tal
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow fetches a git branch
#
#   Inputs:
#       - host - hostname or IP address
#       - port - optional - port number for running the command - Default: 22
#       - username - username to connect as
#       - password - password of user
#       - sudo_user - true or false, whether the command should execute using sudo
#       - git_fetch_remote - specify the remote branch to fetch from - Default: origin
#       - git_repository_localdir - the target directory where a git repository exists and git_branch should be checked out to - Default: /tmp/repo.git
#       - privateKeyFile - the absolute path to the private key file
#
# Results:
#  SUCCESS: git repository successfully fetched
#  FAILURE: an error when trying to fetch a git branch
#
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
        default: "'/tmp/repo.git'"
        required: true
    - git_fetch_remote:
        default: "'origin'"
        required: false
    - sudo_user:
        default: false
        required: false
    - privateKeyFile:
        required: false

  workflow:
    - git_clone:
        do:
          ssh.ssh_flow:
            - host
            - port:
                required: false
            - sudo_command: "'echo ' + password + ' | sudo -S ' if bool(sudo_user) else ''"
            - git_fetch: "' && git fetch ' + git_fetch_remote "
            - command: "sudo_command + 'cd ' + git_repository_localdir + git_fetch + ' && echo GIT_SUCCESS'"
            - username
            - password:
                required: false
            - privateKeyFile:
                  required: false
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
