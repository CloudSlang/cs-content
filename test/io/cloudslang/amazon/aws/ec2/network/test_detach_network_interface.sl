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
####################################################

namespace: io.cloudslang.amazon.aws.ec2.network

imports:
  network: io.cloudslang.amazon.aws.ec2.network
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_detach_network_interface

  inputs:
    - endpoint
    - identity
    - credential
    - proxy_host:
        default: ''
        required: false
    - proxy_port:
        default: ''
        required: false
    - proxy_username:
        default: ''
        required: false
    - proxy_password:
        default: ''
        required: false
    - headers:
        default: ''
        required: false
    - query_params:
        default: ''
        required: false
    - attachment_id
    - force_detach:
        default: 'false'
        required: false
    - version

  workflow:
    - detach_network_interface:
        do:
          network.detach_network_interface:
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers
            - query_params
            - attachment_id
            - force_detach
            - version
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_result
          - FAILURE: DETACH_NETWORK_INTERFACE_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(exception) + "," + return_code)}
            - list_2: ",0"
        navigate:
          - SUCCESS: check_detach_network_interface_message_exist
          - FAILURE: CHECK_RESULT_FAILURE

    - check_detach_network_interface_message_exist:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_DETACH_NETWORK_INTERFACE_MESSAGE_FAILURE

  results:
    - SUCCESS
    - DETACH_NETWORK_INTERFACE_FAILURE
    - CHECK_RESULT_FAILURE
    - CHECK_DETACH_NETWORK_INTERFACE_MESSAGE_FAILURE