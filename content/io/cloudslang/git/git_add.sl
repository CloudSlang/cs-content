# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs a git command to add files as staged files for a later local commit.
#! @input host: hostname or IP address
#! @input port: optional - port number for running the command
#! @input username: username to connect as
#! @input password: optional - password of user
#! @input sudo_user: optional - true or false, whether the command should execute using sudo - Default: false
#! @input private_key_file: optional - path to private key file
#! @input git_repository_localdir: target directory where a git repository exists - Default: /tmp/repo.git
#! @input git_add_files: optional - files to add/stage - Default: "*"
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
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
  name: git_add

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
      - git_add_files:
          default: "*"
          required: false

  workflow:
      - git_add:
          do:
            ssh.ssh_flow:
              - host
              - port
              - username
              - password
              - privateKeyFile: ${ private_key_file }
              - git_add: ${ ' git add ' + git_add_files }
              - command: ${ 'cd ' + git_repository_localdir + ' && ' + git_add + ' && echo GIT_SUCCESS' }

          publish:
            - return_result
            - standard_err
            - standard_out
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
    - standard_err
    - standard_out
    - exception
    - command_return_code
    - return_code
