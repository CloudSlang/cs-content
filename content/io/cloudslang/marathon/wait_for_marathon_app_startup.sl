#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Wait for Marathon app startup.
#! @input marathon_host: Marathon host
#! @input marathon_port: optional - Marathon port
#! @input created_app_id: Marathon app id
#! @input attempts: optional - attempts to reach host - Default: 1
#! @input time_to_sleep: optional - time in seconds to wait between attempts - Default: 1
#!!#
####################################################

namespace: io.cloudslang.marathon

imports:
  marathon: io.cloudslang.marathon
  strings: io.cloudslang.base.strings
  math: io.cloudslang.base.math
  utils: io.cloudslang.base.utils
  print: io.cloudslang.base.print
flow:
  name: wait_for_marathon_app_startup
  inputs:
    - marathon_host
    - marathon_port:
        default: "8080"
        required: false
    - created_app_id
    - attempts: 1
    - time_to_sleep:
        default: 1
        required: false
  workflow:

    - list_marathon_apps:
        do:
          marathon.get_apps_list:
            - marathon_host
            - marathon_port
        publish:
          - return_result
        navigate:
          - SUCCESS: parse_response
          - FAILURE: check_if_timed_out

    - parse_response:
         do:
           marathon.parse_get_app_list:
             - operation_response: ${return_result}
         publish:
           - app_list
         navigate:
           - SUCCESS: check_app_was_created
           - FAILURE: FAILURE

    - check_app_was_created:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${app_list}
            - string_to_find: ${created_app_id}
        publish:
          - return_result
        navigate:
          - SUCCESS: list_mesos_tasks
          - FAILURE: check_if_timed_out

    - list_mesos_tasks:
        do:
          marathon.get_tasks_list:
            - marathon_host
            - marathon_port
        publish:
          - tasks_list: ${return_result}
        navigate:
          - SUCCESS: print_before_check_task
          - FAILURE: check_if_timed_out

    - print_before_check_task:
        do:
          print.print_text:
              - text: "Check if task was created."
        navigate:
          - SUCCESS: check_task_was_created

    - check_task_was_created:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${tasks_list}
            - string_to_find: ${created_app_id}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: print_before_check_timeout

    - print_before_check_timeout:
        do:
          print.print_text:
              - text: "Check if timeout after check that task was created failed."
        navigate:
          - SUCCESS: check_if_timed_out

    - check_if_timed_out:
         do:
            math.compare_numbers:
              - value1: ${attempts}
              - value2: 0
         navigate:
           - GREATER_THAN: wait
           - EQUALS: FAILURE
           - LESS_THAN: FAILURE

    - wait:
        do:
          utils.sleep:
              - seconds: ${time_to_sleep}
              - attempts
        publish:
          - attempts: ${attempts - 1}
        navigate:
          - SUCCESS: list_marathon_apps
          - FAILURE: FAILURE

  outputs:
    - SUCCESS
    - FAILURE
