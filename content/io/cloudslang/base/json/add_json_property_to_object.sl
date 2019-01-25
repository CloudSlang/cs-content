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
#! @description: Adds a JSON object under specified key in existing JSON.
#!
#! @input json_object: Existing JSON object.
#!                     Example: '{"server": {"security_groups": [{"name": "default"}], "networks": []}}'
#! @input key: Key where the new JSON object will be added.
#!             Example: 'block_device_mapping_v2'
#! @input value: The JSON object to add.
#!               Example: '{"source_type": "image", "uuid": "b67f9da0-4a89-4588-b0f5-bf4d19401743", "boot_index": "0"}'
#!
#! @output return_result: JSON object updated.
#! @output return_code: "0" if success, "-1" otherwise.
#! @output error_message: Error message if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The operation executed successfully and the 'return_code' is 0.
#! @result FAILURE: The operation could not be executed or the value of the 'return_code' is different than 0.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.json

operation:
  name: add_json_property_to_object

  inputs:
    - json_object
    - key
    - value

  python_action:
    script: |
      try:
        import json, re
        object_quote = None
        value_quote = None
        for c in json_object:
          if c in ['\'', '\"']:
            object_quote = c
            break
        for c in value:
          if c in ['\'', '\"']:
            value_quote = c
            break
        if object_quote == '\'':
          json_object = str(re.sub(r"(?<!\\)(\')",'"', json_object))
          json_object = str(re.sub(r"(\\')",'\'', json_object))
        if value_quote == '\'':
          value = str(re.sub(r"(?<!\\)(\')",'"', value))
          value = str(re.sub(r"(\\')",'\'', value))
        decoded = json.loads(json_object)
        decoded_value = json.loads(value)
        decoded[key] = decoded_value

        encoded_json = json.dumps(decoded)
        if object_quote == '\'':
          encoded_json = encoded_json.replace('\'','\\\'').replace('\"','\'')
        return_code = '0'
      except Exception as ex:
        error_message = ex
        return_code = '-1'

  outputs:
    - return_result: ${ encoded_json if return_code == '0' else '' }
    - return_code
    - error_message: ${ str(error_message) if return_code == '-1' else '' }

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE