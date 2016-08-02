#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Deletes unused and dangling Docker images.
#! @input docker_options: optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input docker_host: Docker machine host
#! @input docker_username: Docker machine username
#! @input docker_password: optional - Docker machine password
#! @input private_key_file: optional - path to the private key file
#! @input timeout: optional - time in milliseconds to wait for the command to complete
#! @input port: optional - SSH port
#! @output amount_of_images_deleted: number of images deleted
#! @output amount_of_dangling_images_deleted: number of dangling images deleted
#! @output dangling_images_list_safe_to_delete: list of dangling images that are safe to delete
#! @output images_list_safe_to_delete: list of images that are safe to delete
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images

flow:
  name: clear_unused_and_dangling_images
  inputs:
    - docker_options:
        required: false
    - docker_host
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - timeout:
        required: false
    - port:
        required: false

  workflow:
     - clear_images:
          do:
            images.clear_unused_images:
              - docker_options
              - docker_host
              - docker_username
              - docker_password
              - private_key_file
              - port
              - timeout
          publish:
            - images_list_safe_to_delete
            - amount_of_images_deleted
            - used_images_list
     - clear_docker_dangling_images:
          do:
            images.clear_dangling_images:
              - docker_options
              - docker_host
              - docker_username
              - docker_password
              - private_key_file
              - used_images: ${ used_images_list }
              - port
              - timeout
          publish:
            - dangling_images_list_safe_to_delete
            - amount_of_dangling_images_deleted
  outputs:
    - amount_of_images_deleted: ${ 0 if 'amount_of_images_deleted' not in locals() else amount_of_images_deleted }
    - amount_of_dangling_images_deleted: ${ 0 if 'amount_of_dangling_images_deleted' not in locals() else amount_of_dangling_images_deleted }
    - dangling_images_list_safe_to_delete
    - images_list_safe_to_delete
