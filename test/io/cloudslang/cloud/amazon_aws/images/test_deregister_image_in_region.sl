#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################

namespace: io.cloudslang.cloud.amazon_aws.images

imports:
  images: io.cloudslang.cloud.amazon_aws.images
  lists: io.cloudslang.base.lists

flow:
  name: test_deregister_image_in_region

  inputs:
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        default: ''
        required: false
    - credential:
        default: ''
        required: false
    - proxy_host:
        default: ''
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - debug_mode:
        default: 'false'
        required: false
    - image_id
    - version

  workflow:
    - deregister_image:
        do:
          images.deregister_image:
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - debug_mode
            - image_id
            - version
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_results
          - FAILURE: DEREGISTER_IMAGE_FAILURE

    - check_results:
        do:
          lists.compare_lists:
            - list_1: ${str(return_result) + "," + return_code + "," + exception}
            - list_2: "The image was successfully deregister.,0,"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULTS_FAILURE

  results:
    - SUCCESS
    - DEREGISTER_IMAGE_FAILURE
    - CHECK_RESULTS_FAILURE
