# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs a git command to cleanup and reinitialized a local repository
#
#    Inputs:
#      - host - hostname or IP address
#      - port - optional - port number for running the command
#      - username - username to connect as
#      - password - optional - password of user
#      - sudo_user - optional- true or false, whether the command should execute using sudo - Default: false
#      - private_key_file - optional - the path to the private key file
#      - git_repository_localdir - the target local directory where is the repository to be cleaned up - Default: /tmp/repo.git
#      - change_path - optional - true or false, whether the command should execute in local path or not - Default: false
#      - new_path - optional - the new path to the directory where is the repository to be cleaned up
#
# Results:
#  SUCCESS: the files was successfully added
#  FAILURE: an error when trying to add files
#
####################################################
namespace: io.cloudslang.git

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: git_cleanup_local_repository

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
    - change_path:
        default: false
        required: false
    - new_path:
        required: false

  workflow:
    - cleanup_repository:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file:
                required: false
            - sudo_command: "'echo ' + password + ' | sudo -S ' if bool(sudo_user) else ''"
            - change_path_command: "'cd ' + (new_path if new_path else '') + ' && ' if bool(change_path) else ''"
            - git_init_command: "' && git reset --hard HEAD'"
            - command: "sudo_command + change_path_command + 'rm -r ' + git_repository_localdir + git_init_command"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE

  outputs:
    - standard_err
    - standard_out
    - command