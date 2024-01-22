#   Copyright 2024 Open Text
#   This program and the accompanying materials
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
#! @description: This operation is used to convert a list to json for gcp labels.
#!
#! @input label_keys: The labels key list separated by comma(,).Keys must conform to the following regexp: [a-zA-Z0-9-_]+, and be less than 128 bytes inlength. This is reflected as part of a URL in the metadata server. Additionally,to avoid ambiguity, keys must not conflict with any other metadata keys for the project.The length of the itemsKeysList must be equal with the length of the itemsValuesList.Optional
#! @input label_values: The labels value list separated by comma(,).Optional
#! @input organizational_key_list: Organizational key list.
#! @input organizational_value_list: Organizational value list.
#!
#! @output label_json: The label json.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2.utils
operation:
  name: list_to_json_for_labels
  inputs:
    - label_keys:
        required: false
    - label_values:
        required: false
    - organizational_key_list
    - organizational_value_list
  python_action:
    use_jython: false
    script: "import json\r\ndef execute(label_keys,label_values,organizational_key_list,organizational_value_list):\r\n    \r\n    final_label_keys = organizational_key_list.split(',')\r\n    final_value_value_list = organizational_value_list.split(',')\r\n    key_list = organizational_key_list\r\n    value_list = organizational_value_list\r\n    if label_keys != '' :\r\n        key_list = key_list + ',' +label_keys\r\n        value_list = value_list + ',' +label_values        \r\n        final_label_keys.extend(label_keys.split(','))\r\n        final_value_value_list.extend(label_values.split(','))\r\n    label_json = dict(zip(final_label_keys,final_value_value_list))\r\n    return {\"label_json\":json.dumps(label_json) , \"key_list\":key_list , \"value_list\":value_list}"
  outputs:
    - label_json
    - key_list
    - value_list
  results:
    - SUCCESS

