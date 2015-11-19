# (c) Copyright 2015 Liran Tal
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow clones a git repository
#
#   Inputs:
#       - host - hostname or IP address
#       - port - optional - port number for running the command - Default: 22
#       - username - username to connect as
#       - password - password of user
#       - sudo_user - true or false, whether the command should execute using sudo
#       - git_repository - the URL for cloning a git repository from
#       - git_repository_localdir - target directory the git repository will be cloned to
#       - privateKeyFile - the absolute path to the private key file
#
# Results:
#  SUCCESS: git repository successfully cloned
#  FAILURE: an error when trying to clone a git repository
#
####################################################
namespace: io.cloudslang.git

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: git_clone_repository

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - git_repository
    - git_repository_localdir: "/tmp/repo.git"
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
            - port
            - sudo_command: ${ 'echo ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - command: ${ sudo_command + 'git clone ' + git_repository + ' ' + git_repository_localdir + ' && echo GIT_SUCCESS' }
            - username
            - password
            - privateKeyFile
        publish:
          - standard_err
          - standard_out

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ standard_out }
            - string_to_find: "GIT_SUCCESS"

  outputs:
    - standard_err
    - standard_out