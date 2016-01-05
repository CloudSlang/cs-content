#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
####################################################
namespace: io.cloudslang.paas.heroku.addons

imports:
  lists: io.cloudslang.base.lists

flow:
  name: test_list_addons_for_application
  inputs:
    - username
    - password
    - app_name_or_id

  workflow:
    - list_addons_for_application:
        do:
          list_addons_for_application:
            - username
            - password
            - app_name_or_id
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: check_result
          FAILURE: LIST_ADDONS_FOR_APPLICATION_FAILURE

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
    - LIST_ADDONS_FOR_APPLICATION_FAILURE
    - CHECK_RESULT_FAILURE