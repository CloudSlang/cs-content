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
namespace: io.cloudslang.heroku.account

imports:
  account: io.cloudslang.heroku.account
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: test_get_account_info

  inputs:
    - username
    - password

  workflow:
    - get_account_info:
        do:
          account.get_account_info:
            - username
            - password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_result
          - FAILURE: GET_ACCOUNT_INFO_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
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
          - FAILURE: get_email

    - get_email:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "email"
        publish:
          - checked_email: ${return_result}
        navigate:
          - SUCCESS: check_email
          - FAILURE: GET_EMAIL_FAILURE

    - check_email:
        do:
          strings.string_equals:
            - first_string: ${username}
            - second_string: ${checked_email}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_EMAIL_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - id
    - checked_email

  results:
    - SUCCESS
    - GET_ACCOUNT_INFO_FAILURE
    - CHECK_RESULT_FAILURE
    - GET_ID_FAILURE
    - ID_IS_NOT_PRESENT
    - GET_EMAIL_FAILURE
    - CHECK_EMAIL_FAILURE
