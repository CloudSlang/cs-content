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
# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
####################################################
namespace: io.cloudslang.heroku.applications

imports:
  apps: io.cloudslang.heroku.applications
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: test_create_application

  inputs:
    - username
    - password
    - name:
        default: ""
        required: false
    - region:
        default: ""
        required: false
    - stack:
        default: ""
        required: false

  workflow:
    - create_application:
        do:
          apps.create_application:
            - username
            - password
            - name
            - region
            - stack
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_result
          - ADD_NAME_FAILURE: ADD_NAME_FAILURE
          - ADD_REGION_FAILURE: ADD_REGION_FAILURE
          - ADD_STACK_FAILURE: ADD_STACK_FAILURE
          - CREATE_APPLICATION_FAILURE: CREATE_APPLICATION_FAILURE
          - GET_ID_FAILURE: GET_ID_FAILURE
          - GET_NAME_FAILURE: GET_NAME_FAILURE
          - GET_CREATED_AT_FAILURE: GET_CREATED_AT_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,201"
        navigate:
          - SUCCESS: get_id
          - FAILURE: CHECK_RESULT_FAILURE

    - get_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "id"
        publish:
          - id: ${return_result}
        navigate:
          - SUCCESS: check_id_is_present
          - FAILURE: GET_ID_FAILURE

    - check_id_is_present:
        do:
          strings.string_equals:
            - first_string: ${id}
            - second_string: None
        navigate:
          - SUCCESS: ID_IS_NOT_PRESENT
          - FAILURE: get_name_from_response

    - get_name_from_response:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "name"
        publish:
          - checked_name: ${return_result}
        navigate:
          - SUCCESS: check_name_is_present
          - FAILURE: GET_NAME_FAILURE

    - check_name_is_present:
        do:
          strings.string_equals:
            - first_string: ${checked_name}
            - second_string: None
        navigate:
          - SUCCESS: CHECK_NAME_IS_NOT_PRESENT
          - FAILURE: verify_names

    - verify_names:
        do:
          strings.string_equals:
            - first_string: ${checked_name}
            - second_string: ${name if name in locals() else checked_name}
        navigate:
          - SUCCESS: get_created_at
          - FAILURE: NAMES_ARE_NOT_THE_SAME

    - get_created_at:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "created_at"
        publish:
          - created_at: ${return_result}
        navigate:
          - SUCCESS: check_created_at_is_present
          - FAILURE: GET_CREATED_AT_FAILURE

    - check_created_at_is_present:
        do:
          strings.string_equals:
            - first_string: ${created_at}
            - second_string: None
        navigate:
          - SUCCESS: CREATED_AT_IS_NOT_PRESENT
          - FAILURE: SUCCESS

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - id
    - checked_name
    - created_at

  results:
    - SUCCESS
    - ADD_NAME_FAILURE
    - ADD_REGION_FAILURE
    - ADD_STACK_FAILURE
    - CREATE_APPLICATION_FAILURE
    - GET_NAME_FAILURE
    - GET_CREATED_AT_FAILURE
    - CHECK_RESULT_FAILURE
    - GET_ID_FAILURE
    - ID_IS_NOT_PRESENT
    - CHECK_NAME_IS_NOT_PRESENT
    - NAMES_ARE_NOT_THE_SAME
    - CREATED_AT_IS_NOT_PRESENT
