#   Copyright 2023 Open Text
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
#! @description: list the tags and labels.
#!
#! @input tags_list: List of tags, separated by the <list_delimiter> delimiter.
#!                   Example:"test,test1"
#!                   Optional
#! @input label_key: List of Keys, separated by the <list_delimiter> delimiter.
#!                   Example:"test,test1"
#!                   Optional
#! @input label_value: List of values, separated by the <list_delimiter> delimiter.
#!                     Example:"test,test1"
#!                     Optional
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2.instances.subflows
operation:
  name: get_labels
  inputs:
    - tags_list:
        required: false
    - label_key:
        required: false
    - label_value:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\nimport json\n\ndef execute(tags_list,label_key,label_value):\n    return_code = 0\n    error_message = ''\n    tag=''\n    labelsJson=''\n    tag_start = '\"tags\": { \"items\":'\n    tag_end='},'\n    label_start='\"labels\": {'\n    label_end='},'\n    if tags_list:\n        items = '['+','.join(['\"'+x+'\"' for x in tags_list[0:].split(',')])+']'\n        tag= tag_start + items + tag_end\n    else:\n        tag=''\n        \n       \n    labelKeys = label_key[0:].split(',')\n    labelValues = label_value[0:].split(',')\n    labels =\"\"\n    for i ,j in zip(range(len(labelKeys)) ,range(len(labelValues))) :\n         labels += '\"' + labelKeys[i] + '\" :' +  '\"' + labelValues[j] +  '\"'  + ',' + '\\n'\n    \n    for k in range(len(labelValues) , len(labelKeys)):\n        labels += '\"' + labelKeys[k] + '\" :' + '\"\"'  + ',' + '\\n'\n     \n    labels = labels[:-2]\n    \n    \n    if label_key:\n        labelsJson = label_start + labels + label_end    \n    else:\n        labelsJson='' \n    \n    return{\"tagsJson\":tag,\"labelJson\":labelsJson, \"return_code\": return_code, \"error_message\": error_message}"
  outputs:
    - tagsJson
    - labelJson
  results:
    - SUCCESS

