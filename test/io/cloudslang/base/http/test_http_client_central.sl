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

namespace: io.cloudslang.base.http

imports:
  http: io.cloudslang.base.http
  lists: io.cloudslang.base.lists
  utils: io.cloudslang.base.http
  strings: io.cloudslang.base.strings

flow:
  name: test_http_client_central

  inputs:
    - url
    - username:
        default: ""
        required: false
    - password:
        default: ""
        required: false
    - content_type:
        default: 'application/json'
        private: true
    - auth_type:
         default: "basic"
         required: false
    - body:
         required: false
    - trust_keystore:
        default: ${get_sp('io.cloudslang.base.http.trust_keystore')}
        required: false
    - trust_password:
        default: ${get_sp('io.cloudslang.base.http.trust_password')}
        required: false
        sensitive: true
    - keystore:
        default: ${get_sp('io.cloudslang.base.http.keystore')}
        required: false
    - keystore_password:
        default: ${get_sp('io.cloudslang.base.http.keystore_password')}
        required: false
        sensitive: true

  workflow:
    - get:
        do:
          http.http_client_get:
            - url
            - username
            - password
            - auth_type
            - content_type
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password

        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
        navigate:
          - SUCCESS: second_get
          - FAILURE: HTTP_CLIENT_GET_FAILURE

    - second_get:
        do:
          http.http_client_get:
            - url
            - content_type
            - username
            - password
            - auth_type: "anonymous"
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password

        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
        navigate:
          - SUCCESS: check_results
          - FAILURE: HTTP_CLIENT_SECOND_GET_FAILURE

    - check_results:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: get_CSRF_token_value
          - FAILURE: CHECK_RESULTS_FAILURE

    - get_CSRF_token_value:
        do:
          utils.get_header_value:
            - response_headers
            - header_name: 'X-CSRF-TOKEN'
        publish:
          - token: ${result}
        navigate:
          - SUCCESS: post
          - FAILURE: GET_HEADER_VALUE_FAILURE

    - post:
        do:
          http.http_client_post:
            - url
            - body
            - username
            - password
            - auth_type: "anonymous"
            - content_type
            - headers: ${'X-CSRF-TOKEN:' + token}
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password

        publish:
          - runId: ${return_result}
          - error_message
          - return_code
          - status_code
          - response_headers
        navigate:
              - SUCCESS: check_post_results
              - FAILURE: HTTP_CLIENT_POST_FAILURE

    - check_post_results:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,201"
        navigate:
          - SUCCESS: delete
          - FAILURE: CHECK_POST_RESULTS_FAILURE

    - delete:
        do:
          http.http_client_delete:
            - url: ${url + '?endedBefore=3168065160000&flowUuids=5ca8cc4c-15c7-4e47-87dc-5b7aea8bd11d'}
            - username
            - password
            - auth_type: "anonymous"
            - content_type
            - headers: ${'X-CSRF-TOKEN:' + token}
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password

        publish:
            - return_result
            - error_message
            - return_code
            - status_code
            - response_headers
        navigate:
            - SUCCESS: check_delete_results
            - FAILURE: HTTP_CLIENT_DELETE_FAILURE

    - check_delete_results:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
            - SUCCESS: get_executions
            - FAILURE: CHECK_DELETE_RESULTS_FAILURE

    - get_executions:
        do:
          http.http_client_get:
              - url
              - content_type
              - auth_type: "anonymous"
              - headers: ${'X-CSRF-TOKEN:' + token}
              - trust_all_roots: "false"
              - x_509_hostname_verifier: "strict"
              - trust_keystore
              - trust_password
              - keystore
              - keystore_password

        publish:
            - return_result
            - error_message
            - return_code
            - status_code
            - response_headers
        navigate:
            - SUCCESS: check_results_get_executions
            - FAILURE: HTTP_CLIENT_GET_EXECUTIONS_FAILURE

    - check_results_get_executions:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
            - SUCCESS: check_return_results_from_get_and_post
            - FAILURE: CHECK_RESULTS_GET_EXECUTIONS_FAILURE

    - check_return_results_from_get_and_post:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: ${runId}
        navigate:
            - SUCCESS: FAILURE_THE_ITEM_WAS_NOT_DELETED
            - FAILURE: SUCCESS


  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - result
    - token
    - response_headers

  results:
    - SUCCESS
    - HTTP_CLIENT_GET_FAILURE
    - CHECK_RESULTS_FAILURE
    - GET_HEADER_VALUE_FAILURE
    - HTTP_CLIENT_POST_FAILURE
    - CHECK_POST_RESULTS_FAILURE
    - HTTP_CLIENT_DELETE_FAILURE
    - CHECK_DELETE_RESULTS_FAILURE
    - HTTP_CLIENT_SECOND_GET_FAILURE
    - HTTP_CLIENT_GET_EXECUTIONS_FAILURE
    - CHECK_RESULTS_GET_EXECUTIONS_FAILURE
    - FAILURE_THE_ITEM_WAS_NOT_DELETED
