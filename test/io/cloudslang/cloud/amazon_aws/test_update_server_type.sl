#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################

namespace: io.cloudslang.cloud.amazon_aws

imports:
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_update_server_type

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
    - region:
        default: 'us-east-1'
        required: false
    - server_id
    - server_type:
        default: ''
        required: false
    - operation_timeout:
        default: ''
        required: false
    - pooling_interval:
        default: ''
        required: false

  workflow:
    - update_server_type:
        do:
          update_server_type:
            - provider
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - region
            - server_id
            - server_type
            - operation_timeout
            - pooling_interval
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_result
          - FAILURE: UPDATE_SERVER_TYPE_FAILURE

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
    - UPDATE_SERVER_TYPE_FAILURE
    - CHECK_RESULT_FAILURE