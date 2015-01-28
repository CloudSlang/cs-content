#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#   This flow will delete only the unused Docker images.
#
#   Inputs:
#       - dockerHost - Docker machine host
#       - dockerUsername - Docker machine username
#       - dockerPassword - Docker machine password
#   Outputs:
#       - images_list_safe_to_delete - unused Docker images
#       - amount_of_images_deleted - how many images where deleted
#       - used_images_list - list containing used Docker images
####################################################
namespace: org.openscore.slang.docker.images

imports:
 docker_images: org.openscore.slang.docker.images
 docker_linux: org.openscore.slang.docker.linux
 base_lists: org.openscore.slang.base.lists

flow:
  name: clear_docker_images_flow
  inputs:
    - dockerHost
    - dockerUsername
    - dockerPassword

  workflow:
    validate_linux_machine_ssh_access:
      do:
        docker_linux.validate_linux_machine_ssh_access:
          - host: dockerHost
          - username: dockerUsername
          - password: dockerPassword
    get_all_images:
      do:
        docker_images.get_all_images:
          - host: dockerHost
          - username: dockerUsername
          - password: dockerPassword
      publish:
        - all_images_list: imageList
    get_used_images:
      do:
        docker_images.get_used_images_flow:
          - dockerHost
          - dockerUsername
          - dockerPassword
      publish:
        - used_images_list: used_images_list
    substract_used_images:
      do:
        base_lists.subtract_sets:
          - set_1: all_images_list
          - set_1_delimiter: "' '"
          - set_2: used_images_list
          - set_2_delimiter: "' '"
          - result_set_delimiter: "' '"
      publish:
        - images_list_safe_to_delete: result_set
        - amount_of_images: str(len(result_set.split()))
    delete_images:
      do:
        docker_images.clear_docker_images:
          - host: dockerHost
          - username: dockerUsername
          - password: dockerPassword
          - images: images_list_safe_to_delete
      publish:
        - response

  outputs:
    - images_list_safe_to_delete
    - amount_of_images_deleted: "'0' if images_list_safe_to_delete == '' else amount_of_images"
    - used_images_list