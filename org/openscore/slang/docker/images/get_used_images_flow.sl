#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will return a list of used docker images
#
#   Inputs:
#       - dockerHost - Linux machine IP
#       - dockerUsername - Username
#       - dockerPassword - Password
#   Outputs:
#       - used_images_list - List of Docker images currently used on the machine
####################################################
namespace: org.openscore.slang.docker.images.

imports:
 docker_images: org.openscore.slang.docker.images
 docker_linux: org.openscore.slang.docker.linux

flow:
  name: get_used_images_flow
  inputs:
    - dockerHost
    - dockerUsername
    - dockerPassword

  workflow:
    validate_linux_machine_ssh_access_op:
          do:
            docker_linux.validate_linux_machine_ssh_access:
              - host: dockerHost
              - username: dockerUsername
              - password: dockerPassword
    get_used_images:
      do:
        docker_images.get_used_images:
          - host: dockerHost
          - username: dockerUsername
          - password: dockerPassword
      publish:
        - used_images_list: imageList
  outputs:
    - used_images_list
