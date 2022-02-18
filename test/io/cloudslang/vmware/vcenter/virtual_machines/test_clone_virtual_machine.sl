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

namespace: io.cloudslang.vmware.vcenter.virtual_machines

imports:
  vms: io.cloudslang.vmware.vcenter.virtual_machines
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_clone_virtual_machine

  inputs:
    - host
    - port:
        default: '443'
        required: false
    - protocol:
        default: 'https'
        required: false
    - username:
        required: false
    - password
    - trust_everyone:
        default: 'true'
        required: false
    - data_center_name
    - hostname
    - virtual_machine_name
    - clone_name
    - folder_name:
        default: ''
        required: false
    - clone_host:
        default: ''
        required: false
    - clone_resource_pool:
        default: ''
        required: false
    - clone_data_store:
        default: ''
        required: false
    - thick_provision:
        default: ''
        required: false
    - is_template:
        default: 'false'
        required: false
    - num_cpus:
        default: '1'
        required: false
    - cores_per_socket:
        default: '1'
        required: false
    - memory:
        default: '1024'
        required: false
    - clone_description:
        default: ''
        required: false

  workflow:
    - clone_virtual_machine:
        do:
          vms.clone_virtual_machine:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - data_center_name
            - hostname
            - virtual_machine_name
            - clone_name
            - folder_name
            - clone_host
            - clone_resource_pool
            - clone_data_store
            - thick_provision
            - is_template
            - num_cpus
            - cores_per_socket
            - memory
            - clone_description
        publish:
          - return_result
          - return_code
          - exception : ${exception if exception != None else ''}
        navigate:
          - SUCCESS: check_result
          - FAILURE: CLONE_VIRTUAL_MACHINE_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(exception) + "," + return_code}
            - list_2: ",0"
        navigate:
          - SUCCESS: get_text_occurrence
          - FAILURE: CHECK_RESPONSES_FAILURE

    - get_text_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: "${'successfully cloned'}"
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
    - CLONE_VIRTUAL_MACHINE_FAILURE
    - CHECK_RESPONSES_FAILURE
    - GET_TEXT_OCCURRENCE_FAILURE
