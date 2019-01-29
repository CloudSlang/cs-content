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

flow:
  name: test_http_client_put

  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
    - content_type:
        default: "application/json"
        private: true
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
    - body:
        default: ${'{"id":' + resource_id + ',"name":"' + resource_name + '_updated","status":"sold"}'}
        private: true

  workflow:
    - put:
        do:
          http.http_client_put:
            - url
            - username
            - password
            - content_type
            - proxy_host
            - proxy_port
            - trust_all_roots: "true"
            - x_509_hostname_verifier: "allow_all"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - body
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_results
          - FAILURE: HTTP_CLIENT_PUT_FAILURE

    - check_results:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULTS_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - HTTP_CLIENT_PUT_FAILURE
    - CHECK_RESULTS_FAILURE
