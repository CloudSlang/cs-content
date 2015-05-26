#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: test_pull_image
  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - image_name

  workflow:

    - test_verify_no_images:
        do:
          images.test_verify_no_images:
            - host
            - port
            - username
            - password
        navigate:
          SUCCESS: pull_image
          FAILURE: MACHINE_IS_NOT_CLEAN
          FAIL_VALIDATE_SSH: FAIL_VALIDATE_SSH
          FAIL_GET_ALL_IMAGES_BEFORE: FAIL_GET_ALL_IMAGES_BEFORE

    - pull_image:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name
        publish:
          - return_result
          - error_message
        navigate:
          SUCCESS: get_all_images
          FAILURE: FAIL_PULL_IMAGE

    - get_all_images:
        do:
          images.get_all_images:
            - host
            - port
            - username
            - password
        publish:
          - image_list
        navigate:
          SUCCESS: verify_image_name
          FAILURE: FAIL_GET_ALL_IMAGES

    - verify_image_name:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: image_list
            - string_to_find: image_name + ":latest"
        navigate:
          SUCCESS: clear_image
          FAILURE: FAILURE

    - clear_image:
        do:
          images.clear_docker_images:
            - host
            - port
            - username
            - password
            - images: image_name
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAIL_CLEAR_IMAGE

  results:
    - SUCCESS
    - FAIL_VALIDATE_SSH
    - FAIL_GET_ALL_IMAGES_BEFORE
    - MACHINE_IS_NOT_CLEAN
    - FAIL_PULL_IMAGE
    - FAIL_GET_ALL_IMAGES
    - FAILURE
    - FAIL_CLEAR_IMAGE