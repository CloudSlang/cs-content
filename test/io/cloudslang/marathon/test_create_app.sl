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
  base_strings: io.cloudslang.base.strings
  base_print: io.cloudslang.base.print
  utils: io.cloudslang.base.utils
flow:
  name: test_create_app
  inputs:
    - marathon_host
    - username
    - private_key_file
    - marathon_port:
        required: false
    - json_file
    - created_app_id

  workflow:
    - setup_marathon:
        do:
          setup_marathon:
            - host: marathon_host
            - username
            - private_key_file
            - marathon_port
        navigate:
          SUCCESS: wait_for_marathon_startup
          CLEAR_CONTAINERS_ON_HOST_PROBLEM: SETUP_MARATHON_PROBLEM
          START_ZOOKEEPER_PROBLEM: SETUP_MARATHON_PROBLEM
          START_MESOS_MASTER_PROBLEM: SETUP_MARATHON_PROBLEM
          START_MESOS_SLAVE_PROBLEM: SETUP_MARATHON_PROBLEM
          START_MARATHON_PROBLEM: SETUP_MARATHON_PROBLEM

    - wait_for_marathon_startup:
        do:
          utils.sleep:
              - seconds: 20

    - list_initial_marathon_apps:
        do:
          get_apps_list:
            - marathon_host
            - marathon_port
        publish:
          - returnResult
        navigate:
          SUCCESS: parse_initial_response
          FAILURE: APPS_NOT_RETRIEVED

    - parse_initial_response:
         do:
           parse_get_app_list:
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
              delete_app:
                - marathon_host
                - marathon_port
                - app_id: app
        navigate:
          SUCCESS: create_marathon_app
          FAILURE: FAIL_TO_DELETE

    - create_marathon_app:
         do:
           create_app:
             - marathon_host
             - marathon_port
             - json_file
         navigate:
           SUCCESS: wait_for_app_startup
           FAILURE: FAIL_TO_CREATE

    - wait_for_app_startup:
        do:
          utils.sleep:
              - seconds: 40

    - list_marathon_apps:
        do:
          get_apps_list:
            - marathon_host
            - marathon_port
        publish:
          - returnResult
        navigate:
          SUCCESS: parse_response
          FAILURE: APPS_NOT_RETRIEVED

    - parse_response:
         do:
           parse_get_app_list:
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
            - string_to_find: created_app_id
        publish:
          - return_result
        navigate:
          SUCCESS: list_mesos_tasks
          FAILURE: APP_NOT_CREATED

    - list_mesos_tasks:
        do:
          get_tasks_list:
            - marathon_host
            - marathon_port
        publish:
          - tasks_list: returnResult
        navigate:
          SUCCESS: check_task_was_created
          FAILURE: TASKS_NOT_RETRIEVED


    - check_task_was_created:
        do:
          base_strings.string_occurrence_counter:
            - string_in_which_to_search: tasks_list
            - string_to_find: created_app_id
        navigate:
          SUCCESS: delete_marathon_app
          FAILURE: TASK_NOT_CREATED

    - delete_marathon_app:
        do:
          delete_app:
             - marathon_host
             - marathon_port
             - app_id: created_app_id
        navigate:
          SUCCESS: list_marathon_apps_again
          FAILURE: FAIL_TO_DELETE

    - list_marathon_apps_again:
        do:
          get_apps_list:
            - marathon_host
            - marathon_port
        publish:
          - returnResult
        navigate:
          SUCCESS: parse_second_response
          FAILURE: APPS_NOT_RETRIEVED

    - parse_second_response:
         do:
           parse_get_app_list:
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
    - SETUP_MARATHON_PROBLEM
    - PARSE_FAILURE
    - FAIL_TO_DELETE
    - APP_NOT_CREATED
    - APPS_NOT_RETRIEVED
    - TASK_NOT_CREATED
    - TASKS_NOT_RETRIEVED
    - FAIL_TO_CREATE
    - FAIL_TO_DELETE
    - APP_STILL_UP

