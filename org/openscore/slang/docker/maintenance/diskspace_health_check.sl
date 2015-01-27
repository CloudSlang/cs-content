#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will check if the diskspace on a linux machine is less than a given percentage.
#
#   Inputs:
#       - dockerHost - Docker machine host
#       - dockerUsername - Docker machine username
#       - dockerPassword - Docker machine password
#       - percentage - ex. (50%)
#   Results:
#       - SUCCESS - diskspace is less than percentage input.
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.docker.maintenance

imports:
 docker_linux: org.openscore.slang.docker.linux
 base_comparisons: org.openscore.slang.base.comparisons

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
        base_comparisons.less_than_percentage:
          - first_percentage: diskSpace
          - second_percentage: percentage
      navigate:
        SUCCESS: SUCCESS
        FAILURE: FAILURE


