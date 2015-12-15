#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################

namespace: io.cloudslang.cloud_provider.amazon_aws

imports:
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: test_start_server
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
    - start_server:
        do:
          start_server:
            - provider
            - endpoint
            - identity
            - credential
            - region
            - server_id
            - proxy_host
            - proxy_port
        navigate:
          SUCCESS: sleep
          FAILURE: START_FAILURE

    - sleep:
        do:
          utils.sleep:
            - seconds
        navigate:
          SUCCESS: list_amazon_instances

    - list_amazon_instances:
        do:
          list_servers:
            - provider
            - endpoint
            - identity
            - credential
            - region
            - proxy_host
            - proxy_port
            - delimiter
        navigate:
          SUCCESS: check_result
          FAILURE: LIST_FAILURE
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
          SUCCESS: SUCCESS
          FAILURE: RUNNING_FAILURE

  results:
    - SUCCESS
    - START_FAILURE
    - LIST_FAILURE
    - RUNNING_FAILURE