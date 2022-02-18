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

namespace: io.cloudslang.openstack.images

imports:
  images: io.cloudslang.openstack.images
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: test_get_image_details

  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - tenant_name
    - image_id
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

  workflow:
    - get_image_details:
        do:
          images.get_image_details:
            - host
            - identity_port
            - compute_port
            - tenant_name
            - image_id
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_get_image_details_result
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          - GET_IMAGE_DETAILS_FAILURE: GET_IMAGE_DETAILS_FAILURE

    - check_get_image_details_result:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: retrieve_image_id
          - FAILURE: CHECK_GET_IMAGE_DETAILS_FAILURE

    - retrieve_image_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "'image','id'"
        publish:
          - retrieved_id: ${return_result}
        navigate:
          - SUCCESS: verify_retrieved_id
          - FAILURE: RETRIEVE_IMAGE_ID_FAILURE

    - verify_retrieved_id:
        do:
          strings.string_equals:
            - first_string: ${image_id}
            - second_string: ${str(retrieved_id)}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: VERIFY_RETRIEVED_ID_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_IMAGE_DETAILS_FAILURE
    - CHECK_GET_IMAGE_DETAILS_FAILURE
    - RETRIEVE_IMAGE_ID_FAILURE
    - VERIFY_RETRIEVED_ID_FAILURE
