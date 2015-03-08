#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will check if the disk space on a Linux machine is less than a given percentage.
#
#   Inputs:
#       - docker_host - Docker machine host
#       - docker_username - Docker machine username
#       - docker_password - Docker machine password
#       - private_key_file - the absolute path to the private key file; Default: none
#       - percentage - ex. (50%)
#   Results:
#       - SUCCESS - disk space is less than percentage input
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.docker.maintenance

imports:
 docker_linux: org.openscore.slang.docker.linux
 base_comparisons: org.openscore.slang.base.comparisons

flow:
  name: diskspace_health_check
  inputs:
    - docker_host
    - docker_username
    - docker_password
    - private_key_file:
        default: "''"
    - percentage

  workflow:
    - validate_linux_machine_ssh_access:
        do:
          docker_linux.validate_linux_machine_ssh_access:
            - host: docker_host
            - username: docker_username
            - password: docker_password
            - privateKeyFile: private_key_file
    - check_disk_space:
        do:
          docker_linux.check_linux_disk_space:
            - host: docker_host
            - username: docker_username
            - password: docker_password
            - privateKeyFile: private_key_file
        publish:
          - disk_space
    - check_availability:
        do:
          base_comparisons.less_than_percentage:
            - first_percentage: disk_space
            - second_percentage: percentage
        navigate:
          LESS: SUCCESS
          MORE: NOT_ENOUGH_DISKSPACE
          FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
    - NOT_ENOUGH_DISKSPACE

