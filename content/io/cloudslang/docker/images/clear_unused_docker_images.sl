#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#  Deletes unused and Dangling Docker images.
#
#  Inputs:
#    - docker_options - optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#    - docker_host - Docker machine host
#    - docker_username - Docker machine username
#    - docker_password - optional - Docker machine password - Default: none
#    - private_key_file - optional - path to the private key file - Default: none
#    - timeout - optional - time in milliseconds to wait for the command to complete
#  Outputs:
#    - amount_of_images_deleted - number of images deleted
#    - amount_of_dangling_images_deleted - number of dangling images deleted
#    - dangling_images_list_safe_to_delete - list of dangling images that are safe to delete
#    - images_list_safe_to_delete - list of images that are safe to delete
####################################################

namespace: io.cloudslang.docker.images

imports:
 docker_images: io.cloudslang.docker.images
 base_os_linux: io.cloudslang.base.os.linux

flow:
  name: clear_unused_docker_images
  inputs:
    - docker_options:
        required: false
    - docker_host
    - docker_username
    - docker_password:
        required: false
    - private_key_file:
        required: false
    - timeout:
        required: false
    - port:
        required: false
  workflow:
     - clear_docker_images:
          do:
            docker_images.clear_docker_images_flow:
              - docker_options:
                  required: false
              - docker_host
              - docker_username
              - docker_password:
                  required: false
              - private_key_file:
                  required: false
              - port:
                  required: false
              - timeout:
                  required: false
          publish:
            - images_list_safe_to_delete
            - amount_of_images_deleted
            - used_images_list
     - clear_docker_dangling_images:
          do:
            docker_images.clear_docker_dangling_images_flow:
              - docker_options:
                  required: false
              - docker_host
              - docker_username
              - docker_password:
                  required: false
              - private_key_file:
                  required: false
              - used_images: used_images_list
              - port:
                  required: false
              - timeout:
                  required: false
          publish:
            - dangling_images_list_safe_to_delete
            - amount_of_dangling_images_deleted
  outputs:
    - amount_of_images_deleted: "0 if 'amount_of_images_deleted' not in locals() else amount_of_images_deleted"
    - amount_of_dangling_images_deleted: "0 if 'amount_of_images_deleted' not in locals() else amount_of_dangling_images_deleted"
    - dangling_images_list_safe_to_delete
    - images_list_safe_to_delete
