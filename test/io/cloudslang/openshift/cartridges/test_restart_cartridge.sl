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
namespace: io.cloudslang.openshift.cartridges

imports:
  cartridges: io.cloudslang.openshift.cartridges
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: test_restart_cartridge

  inputs:
    - host
    - username:
        required: false
    - password:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - domain
    - application_name
    - cartridge

  workflow:
    - restart_cartridge:
        do:
          cartridges.restart_cartridge:
            - host
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - domain
            - application_name
            - cartridge
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_result
          - FAILURE: RESTART_CARTRIDGE_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: get_status
          - FAILURE: CHECK_RESPONSES_FAILURE

    - get_status:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "status"
        publish:
          - status: ${return_result}
        navigate:
          - SUCCESS: verify_status
          - FAILURE: GET_STATUS_FAILURE

    - verify_status:
        do:
          strings.string_equals:
            - first_string: 'ok'
            - second_string: ${status}
        navigate:
          - SUCCESS: get_text_messages
          - FAILURE: VERIFY_STATUS_FAILURE

    - get_text_messages:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "messages,0,text"
        publish:
          - messages: ${return_result}
        navigate:
          - SUCCESS: get_text_occurrence
          - FAILURE: GET_TEXT_MESSAGES_FAILURE

    - get_text_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${messages}
            - string_to_find: ${'Restarted ' + cartridge + ' on ' + application_name}
            - ignore_case: "true"
        publish:
          - text_occurrence: ${return_result}
        navigate:
          - SUCCESS: verify_text
          - FAILURE: GET_TEXT_OCCURRENCE_FAILURE

    - verify_text:
        do:
          strings.string_equals:
            - first_string: ${text_occurrence}
            - second_string: ${str(1)}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: VERIFY_TEXT_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - RESTART_CARTRIDGE_FAILURE
    - CHECK_RESPONSES_FAILURE
    - GET_STATUS_FAILURE
    - VERIFY_STATUS_FAILURE
    - GET_TEXT_MESSAGES_FAILURE
    - GET_TEXT_OCCURRENCE_FAILURE
    - VERIFY_TEXT_FAILURE
