# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Workflow to test docker get_all_images operation.
#! @input host: Docker machine host
#! @input port: Docker machine port
#! @input username: Docker machine username
#! @input password: Docker machine password
#! @input image_name: Docker image name to pull
#! @result SUCCESS: get_all_images performed successfully
#! @result FAILURE: get_all_images finished with an error
#! @result DOWNLOADFAIL: prerequest error - could not download dockerimage
#! @result VERIFYFAILURE: fails ro verify downloaded images
#! @result DELETEFAIL: fails to delete downloaded image
#! @result MACHINE_IS_NOT_CLEAN: prerequest fails - machine is not clean
#! @result FAIL_VALIDATE_SSH: ssh connection fails
#! @result FAIL_GET_ALL_IMAGES_BEFORE: fails to verify machine images
#!!# PROCCESSED
####################################################
namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  strings: io.cloudslang.base.strings

flow:
  name: test_get_all_images_outputs

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
          - SUCCESS: hello_world_image_download
          - FAILURE: MACHINE_IS_NOT_CLEAN
          - FAIL_VALIDATE_SSH: FAIL_VALIDATE_SSH
          - FAIL_GET_ALL_IMAGES_BEFORE: FAIL_GET_ALL_IMAGES_BEFORE

    - hello_world_image_download:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name
        navigate:
          - SUCCESS: get_all_images
          - FAILURE: DOWNLOADFAIL

    - get_all_images:
        do:
          images.get_all_images:
            - host
            - port
            - username
            - password
        publish:
            - list: ${image_list}
        navigate:
          - SUCCESS: verify_output
          - FAILURE: FAILURE

    - verify_output:
        do:
          strings.string_equals:
            - first_string: ${ image_name + ' ' }
            - second_string: ${ list }
        navigate:
          - SUCCESS: delete_downloaded_image
          - FAILURE: VERIFYFAILURE

    - delete_downloaded_image:
        do:
          images.clear_images:
            - host
            - port
            - username
            - password
            - images: ${ image_name }
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: DELETEFAIL

  results:
    - SUCCESS
    - FAILURE
    - DOWNLOADFAIL
    - VERIFYFAILURE
    - DELETEFAIL
    - MACHINE_IS_NOT_CLEAN
    - FAIL_VALIDATE_SSH
    - FAIL_GET_ALL_IMAGES_BEFORE
