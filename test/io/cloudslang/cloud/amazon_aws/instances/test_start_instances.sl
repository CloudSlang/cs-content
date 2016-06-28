#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################

namespace: io.cloudslang.cloud.amazon_aws.instances

imports:
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: test_start_instances
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
    - delimiter:
        required: false
    - seconds:
        default: '45'
        required: false

  workflow:
    - start_instances:
        do:
          start_instances:
            - provider
            - endpoint
            - identity
            - credential
            - region
            - server_id
            - proxy_host
            - proxy_port
        navigate:
          - SUCCESS: sleep
          - FAILURE: START_FAILURE

    - sleep:
        do:
          utils.sleep:
            - seconds
        navigate:
          - SUCCESS: describe_instances
          - FAILURE: START_FAILURE

    - describe_instances:
        do:
          describe_instances:
            - provider
            - endpoint
            - identity
            - credential
            - region
            - proxy_host
            - proxy_port
            - delimiter
        navigate:
          - SUCCESS: check_result
          - FAILURE: LIST_FAILURE
        publish:
          - return_result
          - return_code
          - exception

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: ${server_id + ', state=running'}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: RUNNING_FAILURE

  results:
    - SUCCESS
    - START_FAILURE
    - LIST_FAILURE
    - RUNNING_FAILURE
