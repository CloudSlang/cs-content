#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# Deletes unused dangling Docker images.
#
# Inputs:
#   - docker_options - optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#   - docker_host - Docker machine host
#   - docker_username - Docker machine username
#   - docker_password - optional - Docker machine password
#   - private_key_file - optional - absolute path to private key file - Default: none
#   - used_images - list of used images - Format: space delimited list of strings
#   - timeout - optional - time in milliseconds to wait for the command to complete
# Outputs:
#   - images_list_safe_to_delete - unused Docker images (including dangling ones)
#   - amount_of_dangling_images_deleted - number of dangling images that where deleted
# Results:
#   - SUCCESS - successful
#   - FAILURE - otherwise
####################################################
namespace: io.cloudslang.docker.images

imports:
 base_os_linux: io.cloudslang.base.os.linux
 base_lists: io.cloudslang.base.lists

flow:
  name: clear_dangling_images
  inputs:
    - docker_options:
        required: false
    - docker_host
    - docker_username
    - docker_password:
        required: false
    - private_key_file:
        required: false
    - used_images
    - port:
        required: false
    - timeout:
        required: false

  workflow:
    - get_dangling_images:
        do:
          get_dangling_images:
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
          base_lists.subtract_sets:
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
          clear_images:
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
