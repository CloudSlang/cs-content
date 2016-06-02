#   (c) Copyright 2016 Hewlett Packard Enterprise Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Stops the Server Monitor daemon on a remote Linux host
#! @input host: hostname or IP address
#! @input port: optional - port number for running the command - Default: '22'
#! @input username: username to connect as
#! @input password: optional - password of user
#! @input arguments: optional - arguments to pass to the command
#! @input private_key_file: optional - absolute path to private key file - Default: none
#! @input timeout: optional - time in milliseconds to wait for the command to complete - Default: 90000
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8' - Default: 'UTF-8'
#! @input close_session: optional - if 'false' the SSH session will be cached for future calls of this operation during the
#!                       life of the flow, if 'true' the SSH session used by this operation will be closed
#!                       Valid: true, false - Default: false
#! @input agent_forwarding: optional - the sessionObject that holds the connection if the close session is false
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: return code of the command
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: '0' for a successful command, '-1' if the command was not yet terminated (or this
#!                              channel type has no command), '126' if the command cannot execute.
#! @result SUCCESS: SSH access was successful and returned with code '0'
#! @result FAILURE: otherwise
#!!#
####################################################


namespace: io.cloudslang.new_relic.servers

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: stop_server_monitor
  inputs:
    - host
    - port
    - username
    - password:
        sensitive: true
    - command
    - closeSession:
        required: false
        default: ''
    - private_key_file:
        required: false
        default: ''
    - timeout:
        required: false
        default: ''
    - character_set:
        required: false
        default: ''

  workflow:
    - start_server_monitor:
        do:
          ssh.ssh_command:
            - host
            - port
            - username
            - password
            - closeSession
            - command: "/etc/init.d/newrelic-sysmond stop"
            - timeout
            - private_key_file
            - character_set

        publish:
          - return_result
          - standard_out
          - standard_err
          - return_code
          - exception

  outputs:
    - return_result
    - standard_out
    - standard_err
    - return_code
    - exception
