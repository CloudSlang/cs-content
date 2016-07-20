#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Starts a linked container.
#! @input image_name: image name
#! @input container_name: linked container name
#! @input link_params: link parameters
#! @input cmd_params: command parameters
#! @input container_cmd: optional - command to be executed in the container
#! @input host: Docker machine host
#! @input port: optional - SSH port
#! @input username: Docker machine username
#! @input password: optional - Docker machine password
#! @input private_key_file: optional - path to private key file
#! @input arguments: optional - arguments to pass to command
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: SJIS, EUC-JP, UTF-8
#! @input pty: optional - whether to use PTY - Valid: true, false
#! @input timeout: optional - time in milliseconds to wait for command to complete
#! @input close_session: optional - if false SSH session will be cached for future calls during the life of the flow,
#!                       if true the SSH session used will be closed;
#!                       Valid: true, false
#! @output container_id: ID of the container that was started
#! @output error_message: error message
#!!#
####################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: start_linked_container
  inputs:
    - image_name
    - container_name
    - link_params
    - cmd_params
    - container_cmd:
        required: false
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - arguments:
        required: false
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - close_session:
        required: false
    - container_cmd_expression:
        default: ${' ' + container_cmd if container_cmd else ''}
        required: false
        private: true
    - command:
        default: >
          ${'docker run --name ' + container_name + ' --link ' + link_params + ' ' + cmd_params +
          ' -d ' + image_name + container_cmd_expression}
        required: false
        private: true

  workflow:
    - start_linked_container:
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
        publish:
          - return_result
          - standard_err
          - return_code
  outputs:
    - container_id: ${return_result}
    - error_message: ${standard_err if(return_code == '0' and standard_err != '') else return_result}
