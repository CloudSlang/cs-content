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
  name: test_reboot_server

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        required: false
    - credential:
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - server_id
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - reboot_server:
        do:
          reboot_server:
            - provider
            - endpoint
            - identity
            - credential
            - region
            - server_id
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_result
          - FAILURE: REBOOT_SERVER_FAILURE

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
    - REBOOT_SERVER_FAILURE
    - CHECK_RESULT_FAILURE