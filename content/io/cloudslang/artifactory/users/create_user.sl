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
namespace: io.cloudslang.artifactory.users

imports:
 print: io.cloudslang.base.print
 httpClient: io.cloudslang.base.network.rest
 json: io.cloudslang.artifactory.users

flow:
  name: create_user
  inputs:
      - host
      - port
      - admin_user
      - admin_password
      - user_name
      - user_password
      - user_email
      - proxy_host:
          default: ""
          required: false
      - proxy_port:
          default: "8080"
          required: false
      - proxy_username:
          default: ""
          required: false
      - proxy_password:
          default: ""
          required: false
      - connect_timeout:
          default: "0"
          required: false
      - socket_timeout:
          default: "0"
          required: false
  workflow:
      - generate_add_user_json:
          do:
           json.create_user_build_json:
              - user_name
              - user_password
              - user_email
          publish:
            - user_create_json
          navigate:
            - SUCCESS: user_add
            - FAILURE: FAILURE
      - user_add:
          do:
            httpClient.http_client_post:
              - url: "${'http://' + host + ':' + port + '/artifactory/ui/users'}"
              - username: ${admin_user}
              - password: ${admin_password}
              - auth_type: 'basic'
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - connection_timeout
              - socket_timeout
              - content_type: "application/json"
              - body: ${user_create_json}
          publish:
            - return_result
            - error_message
            - return_code
            - status_code

  outputs:
    - message: ${return_result}

  results:
    - SUCCESS
    - FAILURE
