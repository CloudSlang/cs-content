#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Wait for Marathon app startup.
#
# Inputs:
#   - marathon_host - marathon host
#   - marathon_port - marathon port
#   - attempts - attempts to reach host
#   - time_to_sleep - time in seconds to wait between attempts
# Outputs:
#   - output_message - timeout exceeded and url was not accessible
# Results:
#   - SUCCESS - url is accessible
#   - FAILURE - url is not accessible
####################################################

namespace: io.cloudslang.marathon

imports:
  base_strings: io.cloudslang.base.strings
  math: io.cloudslang.base.math
  utils: io.cloudslang.base.utils
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
          get_apps_list:
            - marathon_host
            - marathon_port
        publish:
          - return_result
        navigate:
          SUCCESS: parse_response
          FAILURE: check_if_timed_out

    - parse_response:
         do:
           parse_get_app_list:
             - operation_response: ${return_result}
         publish:
           - app_list
         navigate:
           SUCCESS: check_app_was_created
           FAILURE: FAILURE

    - check_app_was_created:
        do:
          base_strings.string_occurrence_counter:
            - string_in_which_to_search: ${app_list}
            - string_to_find: ${created_app_id}
        publish:
          - return_result
        navigate:
          SUCCESS: SUCCESS
          FAILURE: check_if_timed_out

    - check_if_timed_out:
         do:
            math.comparisons.compare_numbers:
              - value1: ${attempts}
              - value2: 0
         navigate:
           GREATER_THAN: wait
           EQUALS: FAILURE
           LESS_THAN: FAILURE

    - wait:
        do:
          utils.sleep:
              - seconds: ${time_to_sleep}
        publish:
          - attempts: ${self['attempts'] - 1}
        navigate:
          SUCCESS: list_marathon_apps

  outputs:
    - output_message: "Marathon app is not up"
