#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Deletes unused Docker images.
#! @input docker_options: optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input docker_host: Docker machine host
#! @input docker_username: Docker machine username
#! @input docker_password: optional - Docker machine password
#! @input port: optional - SSH port
#! @input private_key_file: optional - path to the private key file
#! @input timeout: optional - time in milliseconds to wait for the command to complete
#! @input all_parent_images: list of parent images
#! @output images_list_safe_to_delete: unused Docker images
#! @output amount_of_images_deleted: how many images where deleted
#! @output used_images_list: list of used Docker images
#! @output updated_all_parent_images: list of parent images - will not be deleted
#! @result SUCCESS: flow ends with SUCCESS:
#! @result FAILURE: some step ended with FAILURE:
#!!#
####################################################
namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  utils: io.cloudslang.docker.utils
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: clear_unused_images
  inputs:
    - docker_options:
        required: false
    - docker_host
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - port:
        required: false
    - private_key_file:
        required: false
    - timeout:
        required: false
    - all_parent_images_input:
        required: false

  workflow:
    - get_all_images:
        do:
          images.get_all_images:
            - docker_options
            - host: ${ docker_host }
            - username: ${ docker_username }
            - password: ${ docker_password }
            - private_key_file
            - port
            - timeout
        publish:
          - all_images_list: ${ image_list }
    - get_used_images:
        do:
          images.get_used_images:
            - docker_options
            - host: ${ docker_host }
            - username: ${ docker_username }
            - password: ${ docker_password }
            - private_key_file
            - port
            - timeout
        publish:
          - used_images_list: ${ image_list }

    - subtract_used_images:
        do:
          lists.subtract_sets:
            - set_1: ${ all_images_list }
            - set_1_delimiter: " "
            - set_2: ${ used_images_list }
            - set_2_delimiter: " "
            - result_set_delimiter: " "
        publish:
          - images_list_safe_to_delete: ${ result_set }
          - amount_of_images: ${ len(result_set.split()) }
    - verify_all_images_list_not_empty:
        do:
          strings.string_equals:
            - first_string: ${ all_images_list }
            - second_string: ""
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: verify_used_images_list_not_empty
    - verify_used_images_list_not_empty:
        do:
          strings.string_equals:
            - first_string: ${ used_images_list }
            - second_string: ""
        navigate:
          - SUCCESS: delete_images
          - FAILURE: get_parent_images
    - get_parent_images:
        loop:
            for: image in used_images_list.split()
            do:
              images.get_image_parent:
                - docker_options
                - docker_host
                - docker_username
                - docker_password
                - image_name: ${ image }
                - private_key_file
                - timeout
                - port
                - all_parent_images_input
            publish:
                - all_parent_images: >
                    ${ all_parent_images_input if all_parent_images_input is not None else "" + parent_image_name + " " }
    - substract_parent_images:
        do:
          lists.subtract_sets:
            - set_1: ${ images_list_safe_to_delete }
            - set_1_delimiter: " "
            - set_2: ${ all_parent_images }
            - set_2_delimiter: " "
            - result_set_delimiter: " "
        publish:
          - images_list_safe_to_delete: ${ result_set }
          - amount_of_images: ${ len(result_set.split()) }
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
    - images_list_safe_to_delete
    - amount_of_images_deleted: ${ 0 if 'images_list_safe_to_delete' in locals() and images_list_safe_to_delete == '' else amount_of_images }
    - used_images_list
    - updated_all_parent_images: ${ get('all_parent_images', 0) }
  results:
    - SUCCESS
    - FAILURE
