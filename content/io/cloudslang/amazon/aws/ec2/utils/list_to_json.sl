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
#! @input tag_key_list: The key tag list separated by comma(,)The length of the items KeysList must be equal with the length of the items ValuesList.Optional
#! @input tag_value_list: The value_tag_list separated by comma(,)The length of the items KeysList must be equal with the length of the items ValuesList.Optional
#! @input organizational_key_list: Organizational key list.
#! @input organizational_value_list: Organizational value list.
#!
#! @output tags_json: List of tags in json format.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.ec2.utils
operation:
  name: list_to_json
  inputs:
    - tag_key_list:
        required: false
    - tag_value_list:
        required: false
    - organizational_key_list: 'business_unit,product_id,product_name,environment'
    - organizational_value_list: 'itom,test,test,test'
  python_action:
    use_jython: false
    script: "import json\ndef execute(tag_key_list,tag_value_list,organizational_key_list,organizational_value_list):\n    \n    final_tag_key_list = organizational_key_list.split(',')\n    final_value_value_list = organizational_value_list.split(',')\n    key_list = organizational_key_list\n    value_list = organizational_value_list\n    if tag_key_list != '' :\n        key_list = key_list + ',' +tag_key_list\n        value_list = value_list + ',' +tag_value_list        \n        final_tag_key_list.extend(tag_key_list.split(','))\n        final_value_value_list.extend(tag_value_list.split(','))\n    tags_json = dict(zip(final_tag_key_list,final_value_value_list))\n    return {\"tags_json\":json.dumps(tags_json) , \"key_list\":key_list , \"value_list\":value_list}"
  outputs:
    - tags_json
    - key_list
    - value_list
  results:
    - SUCCESS