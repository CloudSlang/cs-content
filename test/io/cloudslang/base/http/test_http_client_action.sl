#   (c) Copyright 2014-2017 EntIT Software LLC, a Micro Focus company, L.P.
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
  json: io.cloudslang.base.json
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_http_client_action

  inputs:
    - url
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
    - resource_id
    - resource_name

  workflow:
    - post_create_pet:
        do:
          http.http_client_action:
            - url
            - method: "POST"
            - body: ${'{"id":' + resource_id + ',"name":"' + resource_name + '","status":"available"}'}
            - content_type
            - proxy_host
            - proxy_port
            - trust_all_roots: "true"
            - x_509_hostname_verifier: "allow_all"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: verify_post_create_pet
          - FAILURE: HTTP_CLIENT_POST_FAILURE

    - verify_post_create_pet:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: get_pet_details
          - FAILURE: VERIFY_POST_CREATE_PET_FAILURE

    - get_pet_details:
        do:
          http.http_client_action:
            - url: ${ url + '/' + resource_id }
            - method: "GET"
            - content_type
            - proxy_host
            - proxy_port
            - trust_all_roots: "true"
            - x_509_hostname_verifier: "allow_all"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: verify_get_pet_details
          - FAILURE: GET_PET_DETAILS_FAILURE

    - verify_get_pet_details:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: get_id
          - FAILURE: VERIFY_GET_PET_DETAILS_FAILURE

    - get_id:
        do:
          json.get_value:
            - json_input: ${ return_result }
            - json_path: "id"
        publish:
          - value: ${ return_result }
        navigate:
          - SUCCESS: verify_id
          - FAILURE: GET_ID_FAILURE

    - verify_id:
        do:
          strings.string_equals:
            - first_string: ${ resource_id }
            - second_string: ${ value }
        navigate:
          - SUCCESS: get_name
          - FAILURE: VERIFY_ID_FAILURE

    - get_name:
        do:
          json.get_value:
            - json_input: ${ return_result }
            - json_path: "name"
        publish:
          - value: ${ return_result}
        navigate:
          - SUCCESS: verify_name
          - FAILURE: GET_NAME_FAILURE

    - verify_name:
        do:
          strings.string_equals:
            - first_string: ${ resource_name }
            - second_string: ${ value }
        navigate:
          - SUCCESS: put_update_pet
          - FAILURE: VERIFY_NAME_FAILURE

    - put_update_pet:
        do:
          http.http_client_action:
            - url
            - method: "PUT"
            - body: ${'{"id":' + resource_id + ',"name":"' + resource_name + '_updated","status":"sold"}'}
            - content_type
            - proxy_host
            - proxy_port
            - trust_all_roots: "true"
            - x_509_hostname_verifier: "allow_all"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: verify_put_update_pet
          - FAILURE: HTTP_CLIENT_PUT_FAILURE

    - verify_put_update_pet:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: get_updated_pet_details
          - FAILURE: VERIFY_PUT_UPDATE_PET_FAILURE

    - get_updated_pet_details:
        do:
          http.http_client_action:
            - url: ${ url + '/' + resource_id }
            - method: "GET"
            - content_type
            - proxy_host
            - proxy_port
            - trust_all_roots: "true"
            - x_509_hostname_verifier: "allow_all"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: get_updated_name
          - FAILURE: GET_UPDATED_PET_DETAILS_FAILURE

    - get_updated_name:
        do:
          json.get_value:
            - json_input: ${ return_result }
            - json_path: "name"
        publish:
          - value: ${ return_result }
        navigate:
          - SUCCESS: verify_updated_name
          - FAILURE: GET_UPDATED_NAME_FAILURE

    - verify_updated_name:
        do:
          strings.string_equals:
            - first_string: ${ resource_name + '_updated' }
            - second_string: ${ value }
        navigate:
          - SUCCESS: get_updated_status
          - FAILURE: VERIFY_UPDATED_NAME_FAILURE

    - get_updated_status:
        do:
          json.get_value:
            - json_input: ${ return_result }
            - json_path: "status"
        publish:
          - value: ${ return_result }
        navigate:
          - SUCCESS: verify_updated_status
          - FAILURE: GET_UPDATED_STATUS_FAILURE

    - verify_updated_status:
        do:
          strings.string_equals:
            - first_string: 'sold'
            - second_string: ${ value }
        navigate:
          - SUCCESS: delete_pet
          - FAILURE: VERIFY_UPDATED_STATUS_FAILURE

    - delete_pet:
        do:
          http.http_client_action:
            - url: ${ url + '/' + resource_id }
            - method: "DELETE"
            - content_type
            - proxy_host
            - proxy_port
            - trust_all_roots: "true"
            - x_509_hostname_verifier: "allow_all"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: get_pet_after_delete
          - FAILURE: HTTP_CLIENT_DELETE_FAILURE

    - get_pet_after_delete:
        do:
          http.http_client_action:
            - url: ${ url + '/' + resource_id }
            - method: "GET"
            - content_type
            - proxy_host
            - proxy_port
            - trust_all_roots: "true"
            - x_509_hostname_verifier: "allow_all"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - valid_http_status_codes: "404"
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: get_message
          - FAILURE: GET_PET_AFTER_DELETE_FAILURE

    - get_message:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "message"
        publish:
          - value: ${ return_result}
        navigate:
          - SUCCESS: verify_not_found_message
          - FAILURE: GET_MESSAGE_FAILURE

    - verify_not_found_message:
        do:
          strings.string_equals:
            - first_string: 'Pet not found'
            - second_string: ${value}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: VERIFY_NOT_FOUND_MESSAGE_FAILURE

  outputs:
    - return_result
    - error_message
    - status_code
    - return_code
  results:
    - SUCCESS
    - HTTP_CLIENT_POST_FAILURE
    - VERIFY_POST_CREATE_PET_FAILURE
    - GET_PET_DETAILS_FAILURE
    - VERIFY_GET_PET_DETAILS_FAILURE
    - GET_ID_FAILURE
    - VERIFY_ID_FAILURE
    - GET_NAME_FAILURE
    - VERIFY_NAME_FAILURE
    - HTTP_CLIENT_PUT_FAILURE
    - VERIFY_PUT_UPDATE_PET_FAILURE
    - GET_UPDATED_PET_DETAILS_FAILURE
    - GET_UPDATED_NAME_FAILURE
    - VERIFY_UPDATED_NAME_FAILURE
    - GET_UPDATED_STATUS_FAILURE
    - VERIFY_UPDATED_STATUS_FAILURE
    - HTTP_CLIENT_DELETE_FAILURE
    - GET_PET_AFTER_DELETE_FAILURE
    - GET_MESSAGE_FAILURE
    - VERIFY_NOT_FOUND_MESSAGE_FAILURE