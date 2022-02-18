#   (c) Copyright 2022 Micro Focus, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################

namespace: io.cloudslang.marathon

imports:
  marathon: io.cloudslang.marathon
  strings: io.cloudslang.base.strings

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
    - is_core_os

  workflow:
    - setup_marathon_on_different_hosts:
        do:
          marathon.setup_marathon_on_different_hosts:
            - marathon_host
            - username
            - private_key_file
            - marathon_port
            - is_core_os
        navigate:
          - SUCCESS: list_initial_marathon_apps
          - SETUP_MARATHON_PROBLEM: SETUP_MARATHON_PROBLEM
          - WAIT_FOR_MARATHON_STARTUP_TIMED_OUT: WAIT_FOR_MARATHON_STARTUP_TIMED_OUT

    - list_initial_marathon_apps:
        do:
          marathon.get_apps_list:
            - marathon_host
            - marathon_port
        publish:
          - return_result
        navigate:
          - SUCCESS: parse_initial_response
          - FAILURE: APPS_NOT_RETRIEVED

    - parse_initial_response:
        do:
          marathon.parse_get_app_list:
            - operation_response: ${return_result}
        publish:
          - app_list
        navigate:
          - SUCCESS: check_if_list_is_empty
          - FAILURE: PARSE_FAILURE

    - check_if_list_is_empty:
        do:
          strings.string_equals:
            - first_string: ${app_list}
            - second_string: ''
        navigate:
         - SUCCESS: create_marathon_app
         - FAILURE: delete_initial_apps

    - delete_initial_apps:
        loop:
            for: app in app_list.split(",")
            do:
              marathon.delete_app:
                - marathon_host
                - marathon_port
                - app_id: ${app}
        navigate:
          - SUCCESS: create_marathon_app
          - FAILURE: FAIL_TO_DELETE

    - create_marathon_app:
        do:
          marathon.create_app:
            - marathon_host
            - marathon_port
            - json_file
        navigate:
          - SUCCESS: wait_for_marathon_app_startup
          - FAILURE: FAIL_TO_CREATE

    - wait_for_marathon_app_startup:
        do:
          marathon.wait_for_marathon_app_startup:
              - marathon_host
              - marathon_port
              - created_app_id
              - attempts: '30'
              - time_to_sleep: '20'
        navigate:
          - SUCCESS: list_marathon_apps
          - FAILURE: WAIT_FOR_MARATHON_APP_STARTUP_TIMED_OUT

    - list_marathon_apps:
        do:
          marathon.get_apps_list:
            - marathon_host
            - marathon_port
        publish:
          - return_result
        navigate:
          - SUCCESS: parse_response
          - FAILURE: APPS_NOT_RETRIEVED

    - parse_response:
        do:
          marathon.parse_get_app_list:
            - operation_response: ${return_result}
        publish:
          - app_list
        navigate:
          - SUCCESS: check_app_was_created
          - FAILURE: PARSE_FAILURE

    - check_app_was_created:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${app_list}
            - string_to_find: ${created_app_id}
        publish:
          - return_result
        navigate:
          - SUCCESS: list_mesos_tasks
          - FAILURE: APP_NOT_CREATED

    - list_mesos_tasks:
        do:
          marathon.get_tasks_list:
            - marathon_host
            - marathon_port
        publish:
          - tasks_list: ${return_result}
        navigate:
          - SUCCESS: check_task_was_created
          - FAILURE: TASKS_NOT_RETRIEVED

    - check_task_was_created:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${tasks_list}
            - string_to_find: ${created_app_id}
        navigate:
          - SUCCESS: delete_marathon_app
          - FAILURE: TASK_NOT_CREATED

    - delete_marathon_app:
        do:
          marathon.delete_app:
             - marathon_host
             - marathon_port
             - app_id: ${created_app_id}
        navigate:
          - SUCCESS: list_marathon_apps_again
          - FAILURE: FAIL_TO_DELETE

    - list_marathon_apps_again:
        do:
          marathon.get_apps_list:
            - marathon_host
            - marathon_port
        publish:
          - return_result
        navigate:
          - SUCCESS: parse_second_response
          - FAILURE: APPS_NOT_RETRIEVED

    - parse_second_response:
        do:
          marathon.parse_get_app_list:
            - operation_response: ${return_result}
        publish:
          - app_list
        navigate:
          - SUCCESS: verify_there_are_no_servers
          - FAILURE: PARSE_FAILURE

    - verify_there_are_no_servers:
        do:
          strings.string_equals:
            - first_string: ${app_list}
            - second_string: ''
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: APP_STILL_UP

  results:
    - SUCCESS
    - SETUP_MARATHON_PROBLEM
    - WAIT_FOR_MARATHON_APP_STARTUP_TIMED_OUT
    - WAIT_FOR_MARATHON_STARTUP_TIMED_OUT
    - PARSE_FAILURE
    - APP_NOT_CREATED
    - APPS_NOT_RETRIEVED
    - TASK_NOT_CREATED
    - TASKS_NOT_RETRIEVED
    - FAIL_TO_CREATE
    - FAIL_TO_DELETE
    - APP_STILL_UP
