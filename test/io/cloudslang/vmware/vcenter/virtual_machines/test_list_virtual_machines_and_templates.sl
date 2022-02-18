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

flow:
  name: test_list_virtual_machines_and_templates

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
    - delimiter:
        default: ','
        required: false

  workflow:
    - list_virtual_machines_and_templates:
        do:
          vms.list_virtual_machines_and_templates:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - delimiter
        publish:
          - return_result
          - return_code
          - exception : ${exception if exception != None else ''}
        navigate:
          - SUCCESS: check_result
          - FAILURE: LIST_VIRTUAL_MACHINES_AND_TEMPLATES_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(exception) + "," + return_code}
            - list_2: ",0"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESPONSES_FAILURE

  outputs:
    - return_result
    - return_code
    - exception

  results:
    - SUCCESS
    - LIST_VIRTUAL_MACHINES_AND_TEMPLATES_FAILURE
    - CHECK_RESPONSES_FAILURE
