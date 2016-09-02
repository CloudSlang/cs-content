#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
####################################################
namespace: io.cloudslang.cloud.heroku.collaborators

imports:
  collaborators: io.cloudslang.cloud.heroku.collaborators
  lists: io.cloudslang.base.lists

flow:
  name: test_list_application_collaborators
  inputs:
    - username
    - password
    - app_id_or_name

  workflow:
    - list_application_collaborators:
        do:
          collaborators.list_application_collaborators:
            - username
            - password
            - app_id_or_name
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_result
          - FAILURE: LIST_APPLICATION_COLLABORATORS_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULT_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - LIST_APPLICATION_COLLABORATORS_FAILURE
    - CHECK_RESULT_FAILURE
