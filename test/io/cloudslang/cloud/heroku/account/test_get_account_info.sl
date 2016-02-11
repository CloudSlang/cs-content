#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
####################################################
namespace: io.cloudslang.cloud.heroku.account

imports:
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: test_get_account_info
  inputs:
    - username
    - password

  workflow:
    - get_account_info:
        do:
          get_account_info:
            - username
            - password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: check_result
          FAILURE: GET_ACCOUNT_INFO_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${[str(error_message), int(return_code), int(status_code)]}
            - list_2: ['', 0, 200]
        navigate:
          SUCCESS: get_id
          FAILURE: CHECK_RESULT_FAILURE

    - get_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['id']
        publish:
          - id: ${value}
        navigate:
          SUCCESS: check_id_is_present
          FAILURE: GET_ID_FAILURE

    - check_id_is_present:
        do:
          strings.string_equals:
            - first_string: ${id}
            - second_string: None
        navigate:
          SUCCESS: ID_IS_NOT_PRESENT
          FAILURE: get_email

    - get_email:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['email']
        publish:
          - checked_email: ${value}
        navigate:
          SUCCESS: check_email
          FAILURE: GET_EMAIL_FAILURE

    - check_email:
        do:
          strings.string_equals:
            - first_string: ${username}
            - second_string: ${checked_email}
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CHECK_EMAIL_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - id
    - checked_email

  results:
    - SUCCESS
    - GET_ACCOUNT_INFO_FAILURE
    - CHECK_RESULT_FAILURE
    - GET_ID_FAILURE
    - ID_IS_NOT_PRESENT
    - GET_EMAIL_FAILURE
    - CHECK_EMAIL_FAILURE