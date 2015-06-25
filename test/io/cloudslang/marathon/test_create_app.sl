#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.marathon

imports:
  marathon: io.cloudslang.marathon
  base_strings: io.cloudslang.base.strings
  base_print: io.cloudslang.base.print
flow:
  name: test_create_app
  inputs:
    - marathon_host
    - marathon_port:
        required: false
    - json_file
    - app_name

  workflow:
    - list_initial_marathon_apps:
        do:
          marathon.get_apps_list:
            - marathon_host
            - marathon_port:
                required: false
        publish:
          - returnResult
        navigate:
          SUCCESS: parse_initial_response
          FAILURE: APPS_NOT_RETRIEVED

    - parse_initial_response:
         do:
           marathon.parse_get_app_list:
             - operation_response: returnResult
         publish:
           - app_list
         navigate:
           SUCCESS: check_if_list_is_empty
           FAILURE: PARSE_FAILURE

    - check_if_list_is_empty:
         do:
            base_strings.string_equals:
              - first_string: app_list
              - second_string: "''"
         navigate:
           SUCCESS: create_marathon_app
           FAILURE: delete_initial_apps

    - delete_initial_apps:
        loop:
            for: 'app in app_list.split(",")'
            do:
              marathon.delete_app:
                - marathon_host
                - marathon_port:
                    required: false
                - app_id: app
        navigate:
          SUCCESS: create_marathon_app
          FAILURE: FAIL_TO_DELETE

    - create_marathon_app:
         do:
           marathon.create_app:
             - marathon_host
             - marathon_port:
                required: false
             - json_file
         navigate:
           SUCCESS: list_marathon_apps
           FAILURE: FAIL_TO_CREATE

    - list_marathon_apps:
        do:
          marathon.get_apps_list:
            - marathon_host
            - marathon_port:
                required: false
        publish:
          - returnResult
        navigate:
          SUCCESS: parse_response
          FAILURE: APPS_NOT_RETRIEVED

    - parse_response:
         do:
           marathon.parse_get_app_list:
             - operation_response: returnResult
         publish:
           - app_list
         navigate:
           SUCCESS: check_app_was_created
           FAILURE: PARSE_FAILURE

    - check_app_was_created:
        do:
          base_strings.string_occurrence_counter:
            - string_in_which_to_search: app_list
            - string_to_find: app_name
        publish:
          - return_result
        navigate:
          SUCCESS: list_mesos_tasks
          FAILURE: APP_NOT_CREATED

    - list_mesos_tasks:
        do:
          marathon.get_tasks_list:
            - marathon_host
            - marathon_port:
                required: false
        publish:
          - tasks_list: returnResult
        navigate:
          SUCCESS: check_task_was_created
          FAILURE: TASKS_NOT_RETRIEVED


    - check_task_was_created:
        do:
          base_strings.string_occurrence_counter:
            - string_in_which_to_search: tasks_list
            - string_to_find: app_name
        navigate:
          SUCCESS: delete_marathon_app
          FAILURE: TASK_NOT_CREATED

    - delete_marathon_app:
        do:
          marathon.delete_app:
             - marathon_host
             - marathon_port:
                required: false
             - app_id: app_name
        navigate:
          SUCCESS: list_marathon_apps_again
          FAILURE: FAIL_TO_DELETE

    - list_marathon_apps_again:
        do:
          marathon.get_apps_list:
            - marathon_host
            - marathon_port:
                required: false
        publish:
          - returnResult
        navigate:
          SUCCESS: parse_second_response
          FAILURE: APPS_NOT_RETRIEVED

    - parse_second_response:
         do:
           marathon.parse_get_app_list:
             - operation_response: returnResult
         publish:
           - app_list
         navigate:
           SUCCESS: verify_there_are_no_servers
           FAILURE: PARSE_FAILURE

    - verify_there_are_no_servers:
         do:
            base_strings.string_equals:
              - first_string: app_list
              - second_string: "''"
         navigate:
           SUCCESS: SUCCESS
           FAILURE: APP_STILL_UP

  results:
    - SUCCESS
    - FAILURE
    - PARSE_FAILURE
    - FAIL_TO_DELETE
    - APP_NOT_CREATED
    - APPS_NOT_RETRIEVED
    - TASK_NOT_CREATED
    - TASKS_NOT_RETRIEVED
    - FAIL_TO_CREATE
    - FAIL_TO_DELETE
    - APP_STILL_UP

