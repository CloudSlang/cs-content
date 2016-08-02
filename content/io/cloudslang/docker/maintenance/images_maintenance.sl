#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Deletes unused Docker images if disk space usage is greater than a given value.
#! @input docker_host: Docker machine host
#! @input docker_username: Docker machine username
#! @input docker_password: optional - Docker machine password
#! @input private_key_file: optional - absolute path to private key file
#! @input percentage: if disk space is greater than this value then unused images will be deleted - Example: 50%
#! @input timeout: optional - time in milliseconds to wait for the command to complete - Default: 6000000
#! @output total_amount_of_images_deleted: number of deleted images
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.maintenance

imports:
 linux: io.cloudslang.base.os.linux
 images: io.cloudslang.docker.images

flow:
  name: images_maintenance
  inputs:
    - docker_host
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - percentage
    - timeout: "6000000"
  workflow:
    - check_diskspace:
        do:
          linux.diskspace_health_check:
            - docker_host
            - docker_username
            - docker_password
            - private_key_file
            - percentage
            - timeout
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
          - NOT_ENOUGH_DISKSPACE: clear_unused_images
    - clear_unused_images:
        do:
          images.clear_unused_and_dangling_images:
            - docker_host
            - docker_username
            - docker_password
            - private_key_file
            - timeout
        publish:
          - amount_of_images_deleted: ${ amount_of_images_deleted if 'amount_of_images_deleted' in locals() and amount_of_images_deleted else 0 }
          - amount_of_dangling_images_deleted: >
              ${ amount_of_dangling_images_deleted if 'amount_of_dangling_images_deleted' in locals() and amount_of_dangling_images_deleted else 0 }
          - dangling_images_list_safe_to_delete
          - images_list_safe_to_delete
          - total_amount: ${ amount_of_images_deleted + amount_of_dangling_images_deleted }
  outputs:
    - total_amount_of_images_deleted: ${ '' if 'total_amount' not in locals() else total_amount }
