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

namespace: io.cloudslang.vmware.vcenter.guest

imports:
  guest: io.cloudslang.vmware.vcenter.guest
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_customize_linux_guest

  inputs:
    - host
    - port:
        default: '443'
        required: false
    - protocol:
        default: 'https'
        required: false
    - username
    - password
    - trust_everyone:
        default: 'true'
        required: false
    - virtual_machine_name
    - computer_name
    - domain:
        default: ''
        required: false
    - ip_address:
        default: ''
        required: false
    - subnet_mask:
        default: ''
        required: false
    - default_gateway:
        default: ''
        required: false
    - hw_clock_utc:
        default: 'true'
        required: false
    - time_zone:
        default: ''
        required: false

  workflow:
    - customize_linux_guest:
        do:
          guest.customize_linux_guest:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - virtual_machine_name
            - computer_name
            - domain
            - ip_address
            - subnet_mask
            - default_gateway
            - hw_clock_utc
            - time_zone
        publish:
          - return_result
          - return_code
          - exception: ${get("exception", '')}
        navigate:
          - SUCCESS: check_result
          - FAILURE: CUSTOMIZE_LINUX_GUEST_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(exception) + "," + return_code}
            - list_2: ",0"
        navigate:
          - SUCCESS: get_text_occurrence
          - FAILURE: CHECK_RESULT_FAILURE

    - get_text_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: "${'successfully customized'}"
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_TEXT_OCCURRENCE_FAILURE

  outputs:
    - return_result
    - return_code
    - exception

  results:
    - SUCCESS
    - CUSTOMIZE_LINUX_GUEST_FAILURE
    - CHECK_RESULT_FAILURE
    - GET_TEXT_OCCURRENCE_FAILURE
