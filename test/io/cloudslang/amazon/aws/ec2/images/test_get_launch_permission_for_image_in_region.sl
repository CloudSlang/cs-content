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
####################################################

namespace: io.cloudslang.amazon.aws.ec2.images

imports:
  images: io.cloudslang.amazon.aws.ec2.images
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_get_launch_permission_for_image_in_region

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        default: ''
        required: false
    - credential:
        default: ''
        required: false
    - proxy_host:
        default: ''
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - debug_mode:
        default: 'false'
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - image_id

  workflow:
    - get_launch_permissions:
        do:
          images.get_launch_permission_for_image_in_region:
            - provider
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - debug_mode
            - region
            - image_id
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_results
          - FAILURE: GET_LAUNCH_PERMISSIONS_FAILURE

    - check_results:
        do:
          lists.compare_lists:
            - list_1: ${return_code + "," + str(exception)}
            - list_2: "0,"
        navigate:
          - SUCCESS: check_message
          - FAILURE: CHECK_RESULTS_FAILURE

    - check_message:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: ""
        navigate:
          - SUCCESS: NO_RETURN_RESULT
          - FAILURE: SUCCESS

  results:
    - SUCCESS
    - GET_LAUNCH_PERMISSIONS_FAILURE
    - CHECK_RESULTS_FAILURE
    - NO_RETURN_RESULT
