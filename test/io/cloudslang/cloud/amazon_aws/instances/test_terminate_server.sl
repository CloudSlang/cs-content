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
  strings: io.cloudslang.base.strings

flow:
  name: test_terminate_server

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
    - terminate_server:
        do:
          terminate_server:
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
          - SUCCESS: check_call_result
          - FAILURE: TERMINATE_SERVER_CALL_FAILURE

    - check_call_result:
        do:
          lists.compare_lists:
            - list_1: ${[str(exception), int(return_code)]}
            - list_2: ['', 0]
        navigate:
          - SUCCESS: check_first_possible_current_state_result
          - FAILURE: CHECK_CALL_RESULT_FAILURE

    - check_first_possible_current_state_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: 'currentState=terminated'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: check_second_possible_current_state_result

    - check_second_possible_current_state_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: 'currentState=shutting-down'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SHUTTING_DOWN_FAILURE

  results:
    - SUCCESS
    - TERMINATE_SERVER_CALL_FAILURE
    - CHECK_CALL_RESULT_FAILURE
    - SHUTTING_DOWN_FAILURE