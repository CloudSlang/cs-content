#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will delete unused Docker images if diskspace is greater than a given value.
#
#   Inputs:
#       - dockerHost - Docker machine host
#       - dockerUsername - Docker machine username
#       - dockerPassword - Docker machine password
#       - percentage - if diskspace is greater than this value then unused images will be deleted - ex. (50%)
#   Outputs:
#       - total_amount_of_images_deleted - how many images were deleted
####################################################

namespace: org.openscore.slang.docker.maintenance

imports:
 docker_maintenance: org.openscore.slang.docker.maintenance
 docker_linux: org.openscore.slang.docker.linux
 docker_images: org.openscore.slang.docker.images

flow:
  name: docker_images_maintenance
  inputs:
    - dockerHost
    - dockerUsername
    - dockerPassword
    - percentage
  workflow:
    check_diskspace:
      do:
        docker_maintenance.diskspace_health_check:
          - dockerHost
          - dockerUsername
          - dockerPassword
          - percentage
      navigate:
        SUCCESS: SUCCESS
        FAILURE: FAILURE
        NOT_ENOUGH_DISKSPACE: clear_unused_docker_images
    clear_unused_docker_images:
      do:
        docker_images.clear_unused_docker_images:
          - dockerHost
          - dockerUsername
          - dockerPassword
      publish:
        - amount_of_images_deleted
        - amount_of_dangling_images_deleted
        - dangling_images_list_safe_to_delete
        - images_list_safe_to_delete
  outputs:
    - total_amount_of_images_deleted: str(int(amount_of_images_deleted) + int(amount_of_dangling_images_deleted))
