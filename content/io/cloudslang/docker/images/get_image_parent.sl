#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Inspects specified image and gets parent.
#! @input docker_options: optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input docker_host: Docker machine host
#! @input docker_username: Docker machine username
#! @input docker_password: optional - Docker machine password
#! @input image_name: image for which to check parents - Example: <repository>:<tag>
#! @input private_key_file: optional - path to the private key file
#! @input timeout: optional - time in milliseconds to wait for the command to complete
#! @input port: optional - port number for running the command
#! @output parent_image_name: name of the parent image
#!!#
####################################################
namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  utils: io.cloudslang.docker.utils

flow:
  name: get_image_parent
  inputs:
    - docker_options:
        required: false
    - docker_host
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - image_name
    - private_key_file:
        required: false
    - timeout:
        required: false
    - port:
        required: false

  workflow:
    - inspect_image:
        do:
          images.inspect_image:
            - docker_options
            - host: ${ docker_host }
            - username: ${ docker_username }
            - password: ${ docker_password }
            - image_name
            - port
            - private_key_file
            - timeout
        publish:
          - image_inspect_json: ${ standard_out }

    - get_parent:
        do:
           utils.parse_inspect_for_parent:
             - json_response: ${ image_inspect_json }
        publish:
          - parent_image

    - get_parent_name:
        do:
           images.get_image_name_from_id:
             - docker_options
             - host: ${ docker_host }
             - username: ${ docker_username }
             - password: ${ docker_password }
             - private_key_file
             - port
             - timeout
             - image_id: ${ parent_image[:10] }
        publish:
          - image_name
  outputs:
    - parent_image_name: ${ image_name }
