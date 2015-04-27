#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# Deletes unused Docker images.
#
# Inputs:
#   - docker_host - Docker machine host
#   - docker_username - Docker machine username
#   - docker_password - Docker machine password
#   - private_key_file - optional - path to the private key file - Default: none
#   - timeout - optional - time in milliseconds to wait for the command to complete
# Outputs:
#   - images_list_safe_to_delete - unused Docker images
#   - amount_of_images_deleted - how many images where deleted
#   - used_images_list - list of used Docker images
# Results:
#   SUCCESS - flow ends with SUCCES
#   FAILURE - some step ended with FAILURE
####################################################
namespace: io.cloudslang.docker.images

imports:
 docker_images: io.cloudslang.docker.images
 docker_utils: io.cloudslang.docker.utils
 base_os_linux: io.cloudslang.base.os.linux
 base_lists: io.cloudslang.base.lists
 base_strings: io.cloudslang.base.strings

flow:
  name: clear_docker_images_flow
  inputs:
    - docker_host
    - docker_username
    - docker_password
    - private_key_file:
        default: "''"
    - timeout:
        required: false
    - all_parent_images:
        default: "''"
  workflow:
    - validate_linux_machine_ssh_access:
        do:
          base_os_linux.validate_linux_machine_ssh_access:
            - host: docker_host
            - username: docker_username
            - password: docker_password
            - privateKeyFile: private_key_file
            - timeout:
                required: false
    - get_all_images:
        do:
          docker_images.get_all_images:
            - host: docker_host
            - username: docker_username
            - password: docker_password
            - privateKeyFile: private_key_file
            - timeout:
                required: false
        publish:
          - all_images_list: image_list
    - get_used_images:
        do:
          docker_images.get_used_images_flow:
            - docker_host
            - docker_username
            - docker_password
            - private_key_file
            - timeout:
                required: false
        publish:
          - used_images_list

    - subtract_used_images:
        do:
          base_lists.subtract_sets:
            - set_1: all_images_list
            - set_1_delimiter: "' '"
            - set_2: used_images_list
            - set_2_delimiter: "' '"
            - result_set_delimiter: "' '"
        publish:
          - images_list_safe_to_delete: result_set
          - amount_of_images: len(result_set.split())
    - verify_all_images_list_not_empty:
        do:
          base_strings.string_equals:
            - first_string: all_images_list
            - second_string: "''"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: verify_used_images_list_not_empty
    - verify_used_images_list_not_empty:
        do:
          base_strings.string_equals:
            - first_string: used_images_list
            - second_string: "''"
        navigate:
          SUCCESS: delete_images
          FAILURE: get_parent_images
    - get_parent_images:
        loop:
            for: image in used_images_list.split()
            do:
              docker_images.get_image_parent:
                - docker_host
                - docker_username
                - docker_password
                - image_name: image
                - private_key_file
                - timeout:
                    required: false
            publish:
                - all_parent_images: >
                    fromInputs['all_parent_images'] + parent_image_name + " "
    - substract_parent_images:
        do:
          base_lists.subtract_sets:
            - set_1: images_list_safe_to_delete
            - set_1_delimiter: "' '"
            - set_2: all_parent_images
            - set_2_delimiter: "' '"
            - result_set_delimiter: "' '"
        publish:
          - images_list_safe_to_delete: result_set
          - amount_of_images: len(result_set.split())
    - delete_images:
        do:
          docker_images.clear_docker_images:
            - host: docker_host
            - username: docker_username
            - password: docker_password
            - privateKeyFile: private_key_file
            - images: images_list_safe_to_delete
            - timeout:
                required: false
        publish:
          - response

  outputs:
    - images_list_safe_to_delete
    - amount_of_images_deleted: "0 if 'images_list_safe_to_delete' in locals() and images_list_safe_to_delete == '' else amount_of_images"
    - used_images_list
    - all_parent_images: "0 if 'all_parent_images' not in locals() else all_parent_images"
  results:
    - SUCCESS
    - FAILURE