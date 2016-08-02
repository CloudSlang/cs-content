#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Deletes unused dangling Docker images.
#! @input docker_options: optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input docker_host: Docker machine host
#! @input docker_username: Docker machine username
#! @input docker_password: optional - Docker machine password
#! @input private_key_file: optional - absolute path to private key file
#! @input used_images: list of used images - Format: space delimited list of strings
#! @input port: optional - SSH port
#! @input timeout: optional - time in milliseconds to wait for the command to complete
#! @output dangling_images_list_safe_to_delete: unused Docker images (including dangling ones)
#! @output amount_of_dangling_images_deleted: number of dangling images that where deleted
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
####################################################
namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  lists: io.cloudslang.base.lists

flow:
  name: clear_dangling_images
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
    - used_images:
        required: false
    - port:
        required: false
    - timeout:
        required: false

  workflow:
    - get_dangling_images:
        do:
          images.get_dangling_images:
            - docker_options
            - host: ${ docker_host }
            - username: ${ docker_username }
            - password: ${ docker_password }
            - private_key_file
            - timeout
            - port
        publish:
          - all_dangling_images: ${ dangling_image_list }
    - substract_used_dangling_images:
        do:
          lists.subtract_sets:
            - set_1: ${ all_dangling_images }
            - set_1_delimiter: " "
            - set_2: ${ used_images }
            - set_2_delimiter: " "
            - result_set_delimiter: " "
        publish:
          - images_list_safe_to_delete: ${ result_set }
          - amount_of_dangling_images: ${ len(result_set.split()) }
    - delete_images:
        do:
          images.clear_images:
            - docker_options
            - host: ${ docker_host }
            - username: ${ docker_username }
            - password: ${ docker_password }
            - private_key_file
            - images: ${ images_list_safe_to_delete }
            - timeout
            - port
        publish:
          - response
  outputs:
    - dangling_images_list_safe_to_delete: ${ images_list_safe_to_delete }
    - amount_of_dangling_images_deleted: ${ 0 if images_list_safe_to_delete == '' else amount_of_dangling_images }
