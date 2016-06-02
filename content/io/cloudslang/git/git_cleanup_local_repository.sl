# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs a git command to cleanup and reinitialize a local repository.
#! @input host: hostname or IP address
#! @input port: optional - port number for running the command
#! @input username: username to connect as
#! @input password: optional - password of user
#! @input sudo_user: optional- true or false, whether the command should execute using sudo - Default: false
#! @input private_key_file: optional - path to private key file
#! @input git_repository_localdir: target local directory where the repository to be cleaned up is located - Default: /tmp/repo.git
#! @input change_path: optional - true or false, whether the command should execute in local path or not - Default: false
#! @input new_path: optional - new path to directory where the repository to be cleaned up is located
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: return code of remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: '0' for a successful command, '-1' if the command was not yet terminated (or this
#!                              channel type has no command), '126' if the command cannot execute
#! @output return_code: return code of the command
#!!#
####################################################
namespace: io.cloudslang.git

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: git_cleanup_local_repository

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - sudo_user:
        default: false
        required: false
    - private_key_file:
        required: false
    - git_repository_localdir: "/tmp/repo.git"
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
            - privateKeyFile: ${ private_key_file }
            - sudo_command: ${ 'echo ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - change_path_command: ${ 'cd ' + (new_path if new_path else '') + ' && ' if bool(change_path) else '' }
            - git_init_command: " && git reset --hard HEAD"
            - command: ${ sudo_command + change_path_command + 'rm -r ' + git_repository_localdir + git_init_command }
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - return_result
    - standard_out
    - standard_err
    - exception
    - command_return_code
    - return_code
