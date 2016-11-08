#   (c) Copyright 2014-2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################

namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: test_verify_no_images
  inputs:
    - host
    - port:
        required: false
    - username
    - password

  workflow:

#temporary task, until get_all_images use the ssh flow
    - validate_ssh:
        do:
          ssh.ssh_command:
            - host
            - port
            - username
            - password
            - command: " "
            - timeout: "30000000"
        navigate:
          - SUCCESS: get_all_images_before
          - FAILURE: FAIL_VALIDATE_SSH

    - get_all_images_before:
        do:
          images.get_all_images:
            - host
            - port
            - username
            - password
        publish:
          - image_list
        navigate:
          - SUCCESS: verify_no_images_before
          - FAILURE: FAIL_GET_ALL_IMAGES_BEFORE

    - verify_no_images_before:
        do:
          strings.string_equals:
            - first_string: ${ image_list }
            - second_string: ""

  results:
    - SUCCESS
    - FAIL_VALIDATE_SSH
    - FAIL_GET_ALL_IMAGES_BEFORE
    - FAILURE
