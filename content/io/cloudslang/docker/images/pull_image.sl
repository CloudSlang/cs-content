#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Pulls a Docker image.
#! @input image_name: image name to be pulled
#! @input host: Docker machine host
#! @input port: optional - SSH port
#! @input username: Docker machine username
#! @input password: optional - Docker machine password
#! @input private_key_file: optional - absolute path to private key file
#! @input arguments: optional - arguments to pass to the command
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: whether to use PTY - Valid: true, false
#! @input timeout: time in milliseconds to wait for command to complete - Default: 30000000
#! @input close_session: optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed; Valid: true, false
#! @input agent_forwarding: optional - whether to forward the user authentication agent
#! @output return_result: response of the operation
#! @output error_message: error message
#! @result SUCCESS:
#! @result FAILURE:
#!!#
####################################################

namespace: io.cloudslang.docker.images

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: pull_image
  inputs:
    - image_name
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - command:
        default: ${ 'docker pull ' + image_name }
        private: true
    - arguments:
        required: false
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        default: "30000000"
        required: false
    - close_session:
        required: false
    - agent_forwarding:
        required: false

  workflow:
    - pull_image:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file
            - command
            - arguments
            - character_set
            - pty
            - timeout
            - close_session
            - agent_forwarding
        publish:
            - return_result
            - error_message: ${ standard_err if return_code == 0 else return_result }
  outputs:
    - return_result
    - error_message
