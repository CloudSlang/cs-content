#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################

namespace: io.cloudslang.cloud.amazon_aws.instances

imports:
  lists: io.cloudslang.base.lists

flow:
  name: test_run_instances

  inputs:
    - provider: 'amazon'
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
    - region:
        default: 'us-east-1'
        required: false
    - availability_zone:
        default: ''
        required: false
    - image_id
    - min_count:
        default: '1'
        required: false
    - max_count:
        default: '1'
        required: false

  workflow:
    - run_instances:
        do:
          run_instances:
            - provider
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - debug_mode
            - region
            - availability_zone
            - image_id
            - min_count
            - max_count
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_result
          - FAILURE: RUN_SERVERS_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${[str(exception), int(return_code)]}
            - list_2: ['', 0]
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULT_FAILURE

  results:
    - SUCCESS
    - RUN_SERVERS_FAILURE
    - CHECK_RESULT_FAILURE