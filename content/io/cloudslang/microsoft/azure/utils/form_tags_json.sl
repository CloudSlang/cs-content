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
#! @description: Form the json body.
#!
#! @input tag_key_list: Custom tag key list.
#! @input tag_value_list: Custom tag value list.
#! @input organizational_key_list: Organizational key list.
#! @input organizational_value_list: Organizational value list.
#!
#! @output tags_json: Tags json.
#! @output key_list: Final key list.
#! @output value_list: Final value list.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.utils
operation:
  name: form_tags_json
  inputs:
    - tag_key_list:
        required: false
    - tag_value_list:
        required: false
    - organizational_key_list
    - organizational_value_list
  python_action:
    use_jython: false
    script: "import json\ndef execute(tag_key_list,tag_value_list,organizational_key_list,organizational_value_list):\n    \n    final_tag_key_list = organizational_key_list.split(',')\n    final_value_value_list = organizational_value_list.split(',')\n    key_list = organizational_key_list\n    value_list = organizational_value_list\n    if tag_key_list != '' :\n        key_list = key_list + ',' +tag_key_list\n        value_list = value_list + ',' +tag_value_list        \n        final_tag_key_list.extend(tag_key_list.split(','))\n        final_value_value_list.extend(tag_value_list.split(','))\n    tags_json = dict(zip(final_tag_key_list,final_value_value_list))\n    return {\"tags_json\":json.dumps(tags_json) , \"key_list\":key_list , \"value_list\":value_list}"
  outputs:
    - tags_json
    - key_list
    - value_list
  results:
    - SUCCESS

