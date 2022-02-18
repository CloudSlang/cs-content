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
namespace: io.cloudslang.base.http

imports:
  http: io.cloudslang.base.http
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json

flow:
  name: test_http_client_delete

  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
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
    - content_type:
        default: "application/json"
        private: true

  workflow:
    - get:
        do:
          http.http_client_get:
            - url: ${url + '/findByStatus?status=available'}
            - username
            - password
            - proxy_host
            - proxy_port
            - content_type
            - trust_all_roots: "true"
            - x_509_hostname_verifier: "allow_all"
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_get_result
          - FAILURE: HTTP_CLIENT_GET_FAILURE

    - check_get_result:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: get_id
          - FAILURE: CHECK_GET_FAILURE

    - get_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "0,id"
        publish:
          - id: ${return_result}
        navigate:
          - SUCCESS: delete
          - FAILURE: GET_ID_FAILURE

    - delete:
        do:
          http.http_client_delete:
            - url: ${url + '/' + str(id)}
            - username
            - password
            - content_type
            - proxy_host
            - proxy_port
            - trust_all_roots: "true"
            - x_509_hostname_verifier: "allow_all"
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_delete_result
          - FAILURE: HTTP_CLIENT_DELETE_FAILURE

    - check_delete_result:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_DELETE_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - id

  results:
    - SUCCESS
    - HTTP_CLIENT_GET_FAILURE
    - CHECK_GET_FAILURE
    - GET_ID_FAILURE
    - HTTP_CLIENT_DELETE_FAILURE
    - CHECK_DELETE_FAILURE
