#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
  name: test_demo_create_app_and_send_mail

  inputs:
    - email_host
    - email_port
    - email_sender
    - email_recipient
    - enable_tls:
        required: false
    - email_username:
        required: false
    - email_password:
        required: false
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
          - SUCCESS: demo_create_app_and_send_mail
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
          - SUCCESS: demo_create_app_and_send_mail
          - FAILURE: FAIL_TO_DELETE

    - demo_create_app_and_send_mail:
        do:
          marathon.demo_create_app_and_send_mail:
            - email_host
            - email_port
            - email_sender
            - email_recipient
            - marathon_host
            - marathon_port
            - json_file
            - enable_tls
            - email_username
            - email_password
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  results:
    - SUCCESS
    - FAILURE
    - SETUP_MARATHON_PROBLEM
    - WAIT_FOR_MARATHON_STARTUP_TIMED_OUT
    - PARSE_FAILURE
    - FAIL_TO_DELETE
    - APPS_NOT_RETRIEVED
