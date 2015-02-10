#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#   This flow will delete only the unused Docker dangling images.
#
#   Inputs:
#       - docker_host - Docker machine host
#       - docker_username - Docker machine username
#       - docker_password - Docker machine password
#       - used_images - list of used images; format is a space separated list of strings
#   Outputs:
#       - images_list_safe_to_delete - unused Docker images (including dangling ones)
#       - amount_of_dangling_images_deleted - how many dangling images where deleted
####################################################
namespace: org.openscore.slang.docker.images

imports:
 docker_images: org.openscore.slang.docker.images
 docker_linux: org.openscore.slang.docker.linux
 base_lists: org.openscore.slang.base.lists

flow:
  name: clear_docker_dangling_images_flow
  inputs:
    - docker_host
    - docker_username
    - docker_password
    - used_images

  workflow:
    validate_linux_machine_ssh_access:
      do:
        docker_linux.validate_linux_machine_ssh_access:
          - host: docker_host
          - username: docker_username
          - password: docker_password
    get_dangling_images:
      do:
        docker_images.get_dangling_images:
          - host: docker_host
          - username: docker_username
          - password: docker_password
      publish:
        - all_dangling_images: dangling_image_list.replace("\n"," ")
    substract_used_dangling_images:
      do:
        base_lists.subtract_sets:
          - set_1: all_dangling_images
          - set_1_delimiter: "' '"
          - set_2: used_images
          - set_2_delimiter: "' '"
          - result_set_delimiter: "' '"
      publish:
        - images_list_safe_to_delete: result_set
        - amount_of_dangling_images: str(len(result_set.split()))
    delete_images:
      do:
        docker_images.clear_docker_images:
          - host: docker_host
          - username: docker_username
          - password: docker_password
          - images: images_list_safe_to_delete
      publish:
        - response
  outputs:
    - dangling_images_list_safe_to_delete: images_list_safe_to_delete
    - amount_of_dangling_images_deleted: "'0' if images_list_safe_to_delete == '' else amount_of_dangling_images"