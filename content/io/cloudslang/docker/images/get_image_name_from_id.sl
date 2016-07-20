#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves the image name from the specified ID.
#! @input docker_options: optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input host: Docker machine host
#! @input port: optional - SSH port - Default: 22
#! @input username: Docker machine username
#! @input password: optional - Docker machine password
#! @input image_id: Docker image ID
#! @input private_key_file: optional - absolute path to private key file
#! @input arguments: optional - arguments to pass to the command
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: optional - whether to use PTY - Valid: true, false - Default: false
#! @input timeout: time in milliseconds to wait for command to complete - Default: 30000000
#! @input close_session: optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed; Valid: true, false
#! @output image_name: name of image
#! @result SUCCESS: SSH command succeeded
#! @result FAILURE: SSH command failed
#!!#
####################################################
namespace: io.cloudslang.docker.images

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: get_image_name_from_id
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
    - image_id:
        required: false
    - private_key_file:
        required: false
    - command:
        default: >
            ${ "docker " + docker_options_expression + "images | grep " + image_id + " | awk '{print $1 \":\" $2}'" }
        private: true
    - arguments:
        required: false
    - character_set:
        required: false
    - pty: "false"
    - timeout: "30000000"
    - close_session: "false"

  workflow:
    - get_image_name_from_id:
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
          - image_name: ${ return_result.replace("\n"," ").replace("<none>:<none> ","").replace("REPOSITORY:TAG ","") }
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
          - FAIL_VALIDATE_SSH: FAILURE

  outputs:
    - image_name
