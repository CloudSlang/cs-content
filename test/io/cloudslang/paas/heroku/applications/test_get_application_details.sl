#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
####################################################

namespace: io.cloudslang.paas.heroku.applications

imports:
  lists: io.cloudslang.base.lists

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
          SUCCESS: SUCCESS
          FAILURE: CHECK_RESULT_FAILURE

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