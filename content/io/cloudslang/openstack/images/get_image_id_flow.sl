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
#!!
#! @description: Retrieves the ID of a specified image within an OpenStack project.
#!
#! @input host: OpenStack machine host
#! @input identity_port: Optional - port used for OpenStack authentication
#!                       Default: '5000'
#! @input compute_port: Optional - port used for OpenStack computations
#!                      Default: '8774'
#! @input tenant_name: name of OpenStack project that contains images to be queried for ID
#! @input image_name: name of image to queried for ID
#! @input username: Optional - username used for URL authentication; for NTLM authentication,
#!                  Format: 'domain\user'
#! @input password: Optional - password used for URL authentication
#! @input proxy_host: Optional - proxy server used to access OpenStack services
#! @input proxy_port: Optional - proxy server port used to access OpenStack services
#!                    Default: '8080'
#! @input proxy_username: Optional - user name used when connecting to proxy
#! @input proxy_password: Optional - proxy server password associated with <proxy_username> input value
#!
#! @output image_id: ID of image
#! @output return_result: response of operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by operation
#!
#! @result SUCCESS: list with images were successfully retrieved
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: authentication token cannot be obtained from authentication call response
#! @result GET_TENANT_ID_FAILURE: tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#! @result GET_AUTHENTICATION_FAILURE: authentication call fails
#! @result LIST_IMAGES_FAILURE: list with images could not be retrieved
#! @result EXTRACT_IMAGES_FAILURE: list with images could not be retrieved
#! @result EXTRACT_IMAGE_ID_FAILURE: parsing of image ID was unsuccessful
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack.images

imports:
  images: io.cloudslang.openstack.images

flow:
  name: get_image_id_flow

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
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true

  workflow:
    - list_images:
        do:
          images.list_images:
            - host
            - identity_port
            - compute_port
            - tenant_name
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
          - image_list
        navigate:
          - SUCCESS: get_image_id
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - LIST_IMAGES_FAILURE: LIST_IMAGES_FAILURE
          - EXTRACT_IMAGES_FAILURE: EXTRACT_IMAGES_FAILURE

    - get_image_id:
        do:
          images.get_image_id:
            - image_body: ${return_result}
            - image_name: ${image_name}
        publish:
          - image_id
          - return_result
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: EXTRACT_IMAGE_ID_FAILURE

  outputs:
    - image_id
    - return_result
    - error_message
    - return_code
    - status_code

  results:
      - SUCCESS
      - GET_AUTHENTICATION_TOKEN_FAILURE
      - GET_TENANT_ID_FAILURE
      - GET_AUTHENTICATION_FAILURE
      - LIST_IMAGES_FAILURE
      - EXTRACT_IMAGES_FAILURE
      - EXTRACT_IMAGE_ID_FAILURE
