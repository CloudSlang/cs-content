#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks if the disk space on a Linux machine is less than a given percentage.
#! @input docker_host: Docker machine host
#! @input docker_username: Docker machine username
#! @input docker_password: optional - Docker machine password
#! @input private_key_file: optional - path to the private key file
#! @input percentage: Example: 50%
#! @input timeout: optional - time in milliseconds to wait for the command to complete
#! @result SUCCESS: disk space less than percentage
#! @result FAILURE: error occurred
#! @result NOT_ENOUGH_DISKSPACE: disk space more than percentage
#!!#
####################################################

namespace: io.cloudslang.base.os.linux

imports:
 base_comparisons: io.cloudslang.base.comparisons
 linux: io.cloudslang.base.os.linux

flow:
  name: diskspace_health_check
  inputs:
    - docker_host
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - percentage
    - timeout:
        required: false

  workflow:
    - validate_linux_machine_ssh_access:
        do:
          linux.validate_linux_machine_ssh_access:
            - host: ${ docker_host }
            - username: ${ docker_username }
            - password: ${ docker_password }
            - private_key_file
            - timeout
    - check_disk_space:
        do:
          linux.check_linux_disk_space:
            - host: ${ docker_host }
            - username: ${ docker_username }
            - password: ${ docker_password }
            - private_key_file
            - timeout
        publish:
          - disk_space
    - check_availability:
        do:
          base_comparisons.less_than_percentage:
            - first_percentage: ${ disk_space.replace("\n", "") }
            - second_percentage: ${ percentage }
        navigate:
          - LESS: SUCCESS
          - MORE: NOT_ENOUGH_DISKSPACE
          - FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
    - NOT_ENOUGH_DISKSPACE
