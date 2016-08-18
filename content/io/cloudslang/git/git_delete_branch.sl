# (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Deletes a git branch
#! @input host: hostname or IP address
#! @input port: optional - port number for running the command
#! @input username: username to connect as
#! @input password: optional - password of user
#! @input git_branch: optional - git branch to delete
#! @input git_repository_localdir: optional - target directory where a git repository exists - Default: /tmp/repo_folder
#! @input sudo_user: optional - true or false, whether the command should execute using sudo - Default: false
#! @input private_key_file: optional - path to private key file
#! @input branch_type: optional - type of branch to delete:local, remote or remote-tracking - Default: local
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
  strings: io.cloudslang.base.strings

flow:
  name: git_delete_branch

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - git_repository_localdir:
        default: "/tmp/repo_folder"
        required: false
    - git_branch
    - sudo_user:
        default: false
        required: false
    - private_key_file:
        required: false
    - branch_type:
        required: false
        default: local

  workflow:
    - git_delete_branch:
    
        do:
          ssh.ssh_flow:
            - git_command: ${'git push origin --delete ' if branch_type == 'remote' else 'git branch -dr ' if branch_type == 'remote-tracking' else 'git branch -d '}
            - host
            - port
            - sudo_command: ${ 'echo ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - command: ${ sudo_command + 'cd ' + git_repository_localdir + ' && ' + git_command + git_branch + ' && echo GIT_SUCCESS' }
            - username
            - password
            - private_key_file
        publish:
          - return_result
          - standard_out
          - standard_err
          - exception
          - command_return_code
          - return_code

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ standard_out }
            - string_to_find: "GIT_SUCCESS"

  outputs:
    - return_result
    - standard_out
    - standard_err
    - exception
    - command_return_code
    - return_code
