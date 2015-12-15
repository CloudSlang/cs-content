#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.paas.heroku.account

imports:
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: test_update_account
  inputs:
    - username
    - password:
        default: None
        required: false
    - allow_tracking:
        default: True
        required: false
    - beta:
        default: False
        required: false
    - account_owner_name:
        default: None
        required: false

  workflow:
    - update_account:
        do:
          update_account:
            - username
            - password
            - allow_tracking
            - beta
            - account_owner_name
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: check_result
          ADD_ALLOW_TRACKING_FAILURE: ADD_ALLOW_TRACKING_FAILURE
          ADD_BETA_FAILURE: ADD_BETA_FAILURE
          ADD_ACCOUNT_OWNER_NAME_FAILURE: ADD_ACCOUNT_OWNER_NAME_FAILURE
          UPDATE_ACCOUNT_FAILURE: UPDATE_ACCOUNT_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${[str(error_message), int(return_code), int(status_code)]}
            - list_2: ['', 0, 200]
        navigate:
          SUCCESS: get_name
          FAILURE: CHECK_RESULT_FAILURE

    - get_name:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['name']
        publish:
          - name: ${value}
        navigate:
          SUCCESS: check_name
          FAILURE: GET_NAME_FAILURE

    - check_name:
        do:
          strings.string_equals:
            - first_string: "Test_CloudSlang"
            - second_string: ${name}
        navigate:
          SUCCESS: get_allow_tracking
          FAILURE: CHECK_NAME_FAILURE

    - get_allow_tracking:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['allow_tracking']
        publish:
          - tracking: ${value}
        navigate:
          SUCCESS: check_allow_tracking
          FAILURE: GET_ALLOW_TRACKING_FAILURE

    - check_allow_tracking:
        do:
          strings.string_equals:
            - first_string: ${allow_tracking}
            - second_string: ${tracking}
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CHECK_ALLOW_TRACKING_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - name
    - tracking

  results:
    - SUCCESS
    - ADD_ALLOW_TRACKING_FAILURE
    - ADD_BETA_FAILURE
    - ADD_ACCOUNT_OWNER_NAME_FAILURE
    - UPDATE_ACCOUNT_FAILURE
    - CHECK_RESULT_FAILURE
    - GET_NAME_FAILURE
    - CHECK_NAME_FAILURE
    - GET_ALLOW_TRACKING_FAILURE
    - CHECK_ALLOW_TRACKING_FAILURE