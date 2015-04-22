#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Deletes unused Docker images if disk space usage is greater than a given value.
#
# Inputs:
#   - docker_host - Docker machine host
#   - docker_username - Docker machine username
#   - docker_password - Docker machine password
#   - private_key_file - optional - absolute path to private key file - Default: none
#   - percentage - if disk space is greater than this value then unused images will be deleted - Example: 50%
#   - timeout - optional - time in milliseconds to wait for the command to complete - Defualt: 6000000
# Outputs:
#   - total_amount_of_images_deleted - number of deleted images
####################################################

namespace: io.cloudslang.docker.maintenance

imports:
 docker_maintenance: io.cloudslang.docker.maintenance
 base_os_linux: io.cloudslang.base.os.linux
 docker_images: io.cloudslang.docker.images

flow:
  name: docker_images_maintenance
  inputs:
    - docker_host
    - docker_username
    - docker_password
    - private_key_file:
        default: "''"
    - percentage
    - timeout:
        default: "'6000000'"
  workflow:
    - check_diskspace:
        do:
          docker_maintenance.diskspace_health_check:
            - docker_host
            - docker_username
            - docker_password
            - private_key_file
            - percentage
            - timeout:
                required: false
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE
          NOT_ENOUGH_DISKSPACE: clear_unused_docker_images
    - clear_unused_docker_images:
        do:
          docker_images.clear_unused_docker_images:
            - docker_host
            - docker_username
            - docker_password
            - private_key_file
            - timeout:
                required: false
        publish:
          - amount_of_images_deleted
          - amount_of_dangling_images_deleted
          - dangling_images_list_safe_to_delete
          - images_list_safe_to_delete
          - total_amount: amount_of_images_deleted + amount_of_dangling_images_deleted
  outputs:
    - total_amount_of_images_deleted: "'' if 'total_amount' not in locals() else total_amount"
