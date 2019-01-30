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

namespace: io.cloudslang.openstack.images

imports:
  images: io.cloudslang.openstack.images
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_get_image_id_flow

  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - tenant_name
    - image_name
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
    - get_image_id_flow:
        do:
          images.get_image_id_flow:
            - host
            - identity_port
            - compute_port
            - tenant_name
            - image_name
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
          - image_id
        navigate:
          - SUCCESS: check_get_image_id_flow_responses
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          - LIST_IMAGES_FAILURE: LIST_IMAGES_FAILURE
          - EXTRACT_IMAGES_FAILURE: EXTRACT_IMAGES_FAILURE
          - EXTRACT_IMAGE_ID_FAILURE: EXTRACT_IMAGE_ID_FAILURE

    - check_get_image_id_flow_responses:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: check_image_id_is_empty
          - FAILURE: CHECK_GET_IMAGE_ID_FLOW_RESPONSES_FAILURE

    - check_image_id_is_empty:
        do:
          strings.string_equals:
            - first_string: ${str(image_id)}
            - second_string: ''
        navigate:
          - SUCCESS: CHECK_IMAGE_ID_IS_EMPTY_FAILURE
          - FAILURE: SUCCESS

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - image_id

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - LIST_IMAGES_FAILURE
    - EXTRACT_IMAGES_FAILURE
    - EXTRACT_IMAGE_ID_FAILURE
    - CHECK_GET_IMAGE_ID_FLOW_RESPONSES_FAILURE
    - CHECK_IMAGE_ID_IS_EMPTY_FAILURE
