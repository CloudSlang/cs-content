#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Deletes specified Docker images.
#! @input docker_options: optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input host: Docker machine host
#! @input port: optional - SSH port
#! @input username: Docker machine username
#! @input password: optional - Docker machine password
#! @input images: list of Docker images to be deleted - Format: 'space delimited'
#! @input private_key_file: optional - absolute path to private key file
#! @input arguments: optional - arguments to pass to the command
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8' - Default: 'UTF-8'
#! @input pty: optional - whether to use PTY; Valid: true, false
#! @input timeout: optional - time in milliseconds to wait for command to complete
#! @input close_session: optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed; Valid: true, false
#! @output response: IDs of the deleted images
#! @output error_message: error message if exists
#! @result SUCCESS:
#! @result FAILURE:
#!!#
####################################################
namespace: io.cloudslang.docker.images

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: clear_images
  inputs:
    - docker_options:
        required: false
    - docker_options_expression:
        default: ${ docker_options + ' ' if bool(docker_options) else '' }
        required: false
        private: true
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - images:
        required: false
    - private_key_file:
        required: false
    - command:
        default: ${ 'docker ' + docker_options_expression + 'rmi ' + images }
        private: true
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

  workflow:
    - clear_images:
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
            - error_message: ${ standard_err }
  outputs:
    - response: ${ return_result }
    - error_message: ${ error_message }
