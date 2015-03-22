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
#   - private_key_file - optional - absolute path to the private key file - Default: none
# Outputs:
#   - images_list_safe_to_delete - unused Docker images
#   - amount_of_images_deleted - how many images where deleted
#   - used_images_list - list of used Docker images
####################################################
namespace: org.openscore.slang.docker.images

imports:
 docker_images: org.openscore.slang.docker.images
 docker_linux: org.openscore.slang.docker.linux
 base_lists: org.openscore.slang.base.lists

flow:
  name: clear_docker_images_flow
  inputs:
    - docker_host
    - docker_username
    - docker_password
    - private_key_file:
        default: "''"

  workflow:
    - validate_linux_machine_ssh_access:
        do:
          docker_linux.validate_linux_machine_ssh_access:
            - host: docker_host
            - username: docker_username
            - password: docker_password
            - privateKeyFile: private_key_file
    - get_all_images:
        do:
          docker_images.get_all_images:
            - host: docker_host
            - username: docker_username
            - password: docker_password
            - privateKeyFile: private_key_file
        publish:
          - all_images_list: image_list
    - get_used_images:
        do:
          docker_images.get_used_images_flow:
            - docker_host
            - docker_username
            - docker_password
            - private_key_file
        publish:
          - used_images_list: used_images_list
    - substract_used_images:
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
    - delete_images:
        do:
          docker_images.clear_docker_images:
            - host: docker_host
            - username: docker_username
            - password: docker_password
            - privateKeyFile: private_key_file
            - images: images_list_safe_to_delete
        publish:
          - response

  outputs:
    - images_list_safe_to_delete
    - amount_of_images_deleted: "0 if images_list_safe_to_delete == '' else amount_of_images"
    - used_images_list