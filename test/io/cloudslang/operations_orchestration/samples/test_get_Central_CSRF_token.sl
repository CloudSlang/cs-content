#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
namespace: io.cloudslang.operations_orchestration.samples

imports:
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: test_get_Central_CSRF_token
  inputs:
    - host
    - port:
        default: '8080'
        required: false
    - protocol:
        default: 'http'
        required: false
    - username:
        default: ''
        required: false
    - password:
        default: ''
        required: false

  workflow:
    - get_Central_CSRF_token:
        do:
          get_Central_CSRF_token:
            - host
            - port
            - protocol
            - username
            - password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
          - token
        navigate:
          - SUCCESS: check_results
          - FAILURE: GET_API_REST_CALL_FAILURE

    - check_results:
        do:
          lists.compare_lists:
            - list_1: ${[str(error_message), int(return_code), int(status_code)]}
            - list_2: ['', 0, 200]
        navigate:
          - SUCCESS: get_version
          - FAILURE: CHECK_RESULTS_FAILURE

    - get_version:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['version']
        publish:
          - version: ${value}
        navigate:
          - SUCCESS: check_response_headers_are_present
          - FAILURE: GET_VERSION_FAILURE

    - check_response_headers_are_present:
        do:
          strings.string_equals:
            - first_string: ${response_headers}
            - second_string: None
        navigate:
          - SUCCESS: RESPONSE_HEADERS_NOT_PRESENT
          - FAILURE: check_token_is_present

    - check_token_is_present:
        do:
          strings.string_equals:
            - first_string: ${token}
            - second_string: None
        navigate:
          - SUCCESS: CSRF_TOKEN_NOT_PRESENT
          - FAILURE: SUCCESS

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - version
    - token

  results:
    - SUCCESS
    - GET_API_REST_CALL_FAILURE
    - CHECK_RESULTS_FAILURE
    - GET_VERSION_FAILURE
    - RESPONSE_HEADERS_NOT_PRESENT
    - CSRF_TOKEN_NOT_PRESENT