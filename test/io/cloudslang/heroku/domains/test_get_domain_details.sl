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
# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
####################################################
namespace: io.cloudslang.heroku.domains

imports:
  domains: io.cloudslang.heroku.domains
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_get_domain_details

  inputs:
    - username
    - password
    - app_id_or_name
    - domain_id_or_hostname

  workflow:
    - get_domain_details:
        do:
          domains.get_domain_details:
            - username
            - password
            - app_id_or_name
            - domain_id_or_hostname
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - id
          - created_at
          - updated_at
        navigate:
          - SUCCESS: check_result
          - GET_DOMAIN_DETAILS_FAILURE: GET_DOMAIN_DETAILS_FAILURE
          - GET_ID_FAILURE: GET_ID_FAILURE
          - GET_CREATED_AT_FAILURE: GET_CREATED_AT_FAILURE
          - GET_UPDATED_AT_FAILURE: GET_UPDATED_AT_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: check_id_is_present
          - FAILURE: CHECK_RESULT_FAILURE

    - check_id_is_present:
        do:
          strings.string_equals:
            - first_string: ${id}
            - second_string: None
        navigate:
          - SUCCESS: ID_IS_NOT_PRESENT
          - FAILURE: check_created_at_is_present

    - check_created_at_is_present:
        do:
          strings.string_equals:
            - first_string: ${created_at}
            - second_string: None
        navigate:
          - SUCCESS: CREATED_AT_IS_NOT_PRESENT
          - FAILURE: SUCCESS

  results:
    - SUCCESS
    - GET_DOMAIN_DETAILS_FAILURE
    - GET_ID_FAILURE
    - GET_CREATED_AT_FAILURE
    - GET_UPDATED_AT_FAILURE
    - CHECK_RESULT_FAILURE
    - ID_IS_NOT_PRESENT
    - CREATED_AT_IS_NOT_PRESENT
