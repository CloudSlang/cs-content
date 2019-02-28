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
#! @description: Creates a boot specific JSON object to be used when an OpenStack server is created
#!
#! @input boot_index: The order in which a hyper-visor tries devices when it attempts to boot the guest from storage.
#!                    To disable a device from booting, the boot index of the device should be a negative value
#!                    - Default: '0'
#! @input uuid: uuid of the image to boot from - Example: 'b67f9da0-4a89-4588-b0f5-bf4d1940174'
#! @input source_type: The source type of the volume - Valid: "", "image", "snapshot" or "volume" - Default: ''
#! @input delete_on_termination: if True then the boot volume will be deleted when the server is destroyed, If false the
#!                               boot volume will be deleted when the server is destroyed.
#!
#! @output boot_json: The boot specific JSON object
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: "0" if success, "-1" otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: successfully created a boot specific JSON object (return_code == '0')
#! @result ADD_BOOT_INDEX_FAILURE: There was an error while trying to add the boot index
#! @result ADD_UUID_FAILURE: There was an error while trying to add the UUID
#! @result ADD_SOURCE_TYPE_FAILURE: There was an error while trying to add the source type
#! @result ADD_DELETE_ON_TERMINATION_FAILURE: There was an error while trying to add delete on termination
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack.utils

imports:
  json: io.cloudslang.base.json

flow:
  name: create_boot_json

  inputs:
    - boot_index
    - uuid
    - source_type
    - delete_on_termination

  workflow:
    - add_boot_index:
        do:
          json.add_value:
            - json_input: "{}"
            - json_path: "boot_index"
            - value: ${boot_index}
        publish:
          - boot_json: ${return_result}
          - error_message
          - return_code
        navigate:
          - SUCCESS: add_uuid
          - FAILURE: ADD_BOOT_INDEX_FAILURE

    - add_uuid:
        do:
          json.add_value:
            - json_input: ${boot_json}
            - json_path: "uuid"
            - value: ${uuid}
        publish:
          - boot_json: ${return_result}
          - error_message
          - return_code
        navigate:
          - SUCCESS: add_source_type
          - FAILURE: ADD_UUID_FAILURE

    - add_source_type:
        do:
          json.add_value:
            - json_input: ${boot_json}
            - json_path: "source_type"
            - value: ${source_type}
        publish:
          - boot_json: ${return_result}
          - error_message
          - return_code
        navigate:
          - SUCCESS: add_delete_on_termination
          - FAILURE: ADD_SOURCE_TYPE_FAILURE

    - add_delete_on_termination:
        do:
          json.add_value:
            - json_input: ${boot_json}
            - json_path: "delete_on_termination"
            - value: ${str(bool(delete_on_termination))}
        publish:
          - boot_json: ${return_result}
          - error_message
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: ADD_DELETE_ON_TERMINATION_FAILURE

  outputs:
    - boot_json
    - return_result
    - return_code
    - error_message

  results:
    - SUCCESS
    - ADD_BOOT_INDEX_FAILURE
    - ADD_UUID_FAILURE
    - ADD_SOURCE_TYPE_FAILURE
    - ADD_DELETE_ON_TERMINATION_FAILURE
