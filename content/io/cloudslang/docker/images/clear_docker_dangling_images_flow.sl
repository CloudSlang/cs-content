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
#   - docker_host - Docker machine host
#   - docker_username - Docker machine username
#   - docker_password - Docker machine password
#   - private_key_file - optional - absolute path to private key file - Default: none
#   - used_images - list of used images - Format: space delimited list of strings
#   - timeout - optional - time in milliseconds to wait for the command to complete
# Outputs:
#   - images_list_safe_to_delete - unused Docker images (including dangling ones)
#   - amount_of_dangling_images_deleted - number of dangling images that where deleted
####################################################
namespace: io.cloudslang.docker.images

imports:
 docker_images: io.cloudslang.docker.images
 base_os_linux: io.cloudslang.base.os.linux
 base_lists: io.cloudslang.base.lists

flow:
  name: clear_docker_dangling_images_flow
  inputs:
    - docker_host
    - docker_username
    - docker_password
    - private_key_file:
        default: "''"
    - used_images
    - timeout:
        required: false

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
    - get_dangling_images:
        do:
          docker_images.get_dangling_images:
            - host: docker_host
            - username: docker_username
            - password: docker_password
            - privateKeyFile: private_key_file
            - timeout:
                required: false
        publish:
          - all_dangling_images: dangling_image_list.replace("\n"," ")
    - substract_used_dangling_images:
        do:
          base_lists.subtract_sets:
            - set_1: all_dangling_images
            - set_1_delimiter: "' '"
            - set_2: used_images
            - set_2_delimiter: "' '"
            - result_set_delimiter: "' '"
        publish:
          - images_list_safe_to_delete: result_set
          - amount_of_dangling_images: len(result_set.split())
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
    - dangling_images_list_safe_to_delete: images_list_safe_to_delete
    - amount_of_dangling_images_deleted: "0 if images_list_safe_to_delete == '' else amount_of_dangling_images"
