#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.paas.heroku.keys

imports:
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json

flow:
  name: test_list_keys
  inputs:
    - username
    - password

  workflow:
    - list_keys:
        do:
          list_keys:
            - username
            - password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: check_result
          FAILURE: LIST_KEYS_FAILURE

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

  results:
    - SUCCESS
    - LIST_KEYS_FAILURE
    - CHECK_RESULT_FAILURE