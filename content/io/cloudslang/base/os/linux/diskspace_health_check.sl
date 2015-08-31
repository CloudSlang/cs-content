#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Checks if the disk space on a Linux machine is less than a given percentage.
#
# Inputs:
#   - docker_host - Docker machine host
#   - docker_username - Docker machine username
#   - docker_password - optional - Docker machine password
#   - private_key_file - optional - path to the private key file - Default: none
#   - percentage - Example: 50%
#   - timeout - optional - time in milliseconds to wait for the command to complete
# Results:
#   - SUCCESS - disk space less than percentage
#   - FAILURE - error occurred
#   - NOT_ENOUGH_DISKSPACE - disk space more than percentage
####################################################

namespace: io.cloudslang.base.os.linux

imports:
 base_comparisons: io.cloudslang.base.comparisons

flow:
  name: diskspace_health_check
  inputs:
    - docker_host
    - docker_username
    - docker_password:
        required: false
    - private_key_file:
        required: false
    - percentage
    - timeout:
        required: false

  workflow:
    - validate_linux_machine_ssh_access:
        do:
          validate_linux_machine_ssh_access:
            - host: docker_host
            - username: docker_username
            - password:
                default: docker_password
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - timeout:
                required: false
    - check_disk_space:
        do:
          check_linux_disk_space:
            - host: docker_host
            - username: docker_username
            - password:
                default: docker_password
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - timeout:
                required: false
        publish:
          - disk_space
    - check_availability:
        do:
          base_comparisons.less_than_percentage:
            - first_percentage: disk_space.replace("\n", "")
            - second_percentage: percentage
        navigate:
          LESS: SUCCESS
          MORE: NOT_ENOUGH_DISKSPACE
          FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
    - NOT_ENOUGH_DISKSPACE

