#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
####################################################

namespace: io.cloudslang.cloud.heroku.applications

imports:
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_get_application_details
  inputs:
    - username
    - password
    - app_id_or_name

  workflow:
    - get_application_details:
        do:
          get_application_details:
            - username
            - password
            - app_id_or_name
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - id
          - name
          - region
          - stack
          - created_at
        navigate:
          SUCCESS: check_result
          GET_APPLICATION_DETAILS_FAILURE: GET_APPLICATION_DETAILS_FAILURE
          GET_ID_FAILURE: GET_ID_FAILURE
          GET_NAME_FAILURE: GET_NAME_FAILURE
          GET_REGION_FAILURE: GET_REGION_FAILURE
          GET_STACK_FAILURE: GET_STACK_FAILURE
          GET_CREATED_AT_FAILURE: GET_CREATED_AT_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${[str(error_message), int(return_code), int(status_code)]}
            - list_2: ['', 0, 200]
        navigate:
          SUCCESS: check_id_is_present
          FAILURE: CHECK_RESULT_FAILURE

    - check_id_is_present:
        do:
          strings.string_equals:
            - first_string: ${id}
            - second_string: None
        navigate:
          SUCCESS: ID_IS_NOT_PRESENT
          FAILURE: check_created_at_is_present

    - check_created_at_is_present:
        do:
          strings.string_equals:
            - first_string: ${created_at}
            - second_string: None
        navigate:
          SUCCESS: CREATED_AT_IS_NOT_PRESENT
          FAILURE: SUCCESS

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - id
    - name
    - region
    - stack
    - created_at

  results:
    - SUCCESS
    - GET_APPLICATION_DETAILS_FAILURE
    - GET_ID_FAILURE
    - GET_NAME_FAILURE
    - GET_REGION_FAILURE
    - GET_STACK_FAILURE
    - GET_CREATED_AT_FAILURE
    - CHECK_RESULT_FAILURE
    - ID_IS_NOT_PRESENT
    - CREATED_AT_IS_NOT_PRESENT