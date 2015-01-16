#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will delete unused images if the disk space on a linux machine is greater than a given input
#   Inputs:
#       - dockerHost - Linux machine IP
#       - dockerUsername - Username
#       - dockerPassword - Password
#       - percentage - Disk space on the linux machine is compared to this number
#   Outputs:
#       - images_list_safe_to_delete - unused docker images
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################

namespace: org.openscore.slang.docker.health-checks

imports:
 comparisons: org.openscore.slang.base.comparisons
 docker_linux: org.openscore.slang.docker.linux
 docker_images: org.openscore.slang.docker.images

flow:
  name: diskspace_health_check
  inputs:
    - dockerHost
    - dockerUsername
    - dockerPassword
    - percentage

  workflow:
    validate_linux_machine_ssh_access:
      do:
        docker_linux.validate_linux_machine_ssh_access:
          - host: dockerHost
          - username: dockerUsername
          - password: dockerPassword
    check_disk_space:
      do:
        docker_linux.check_linux_disk_space:
          - host: dockerHost
          - username: dockerUsername
          - password: dockerPassword
      publish:
        - diskSpace
    check_availability:
      do:
        comparisons.less_than_percentage:
          - first_percentage: diskSpace
          - second_percentage: percentage
      navigate:
        SUCCESS: SUCCESS
        FAILURE: clear_docker_images
    clear_docker_images:
      do:
        docker_images.clear_docker_images_flow:
          - dockerHost
          - dockerUsername
          - dockerPassword
      publish:
        - images_list_safe_to_delete
      navigate:
        SUCCESS: SUCCESS
        FAILURE: FAILURE

