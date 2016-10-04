#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Pulls images using a for loop.
#! @input images_to_pull: images to pull. Format: image1,image2,image3
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
#! @output return_result: response of the operation of last iteration
#! @output error_message: error message of last iteration
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.examples

imports:
  examples: io.cloudslang.docker.examples

flow:
  name: pull_images
  inputs:
    - images_to_pull
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
    - agent_forwarding:
        required: false

  workflow:
    - pull_image_on_host:
        loop:
          for: image in images_to_pull.split(',')
          do:
            examples.pull_image_with_message:
              - image_name: ${image}
              - host
              - port
              - username
              - password
              - private_key_file
              - arguments
              - character_set
              - pty
              - timeout
              - close_session
              - agent_forwarding
          publish:
            - return_result
            - error_message

  outputs:
    - return_result
    - error_message
