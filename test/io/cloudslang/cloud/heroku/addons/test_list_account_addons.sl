#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
####################################################
namespace: io.cloudslang.cloud.heroku.addons

imports:
  addons: io.cloudslang.cloud.heroku.addons
  lists: io.cloudslang.base.lists

flow:
  name: test_list_account_addons

  inputs:
    - username
    - password

  workflow:
    - list_account_addons:
        do:
          addons.list_account_addons:
            - username
            - password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_result
          - FAILURE: LIST_ACCOUNT_ADDONS_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULT_FAILURE

  results:
    - SUCCESS
    - LIST_ACCOUNT_ADDONS_FAILURE
    - CHECK_RESULT_FAILURE
