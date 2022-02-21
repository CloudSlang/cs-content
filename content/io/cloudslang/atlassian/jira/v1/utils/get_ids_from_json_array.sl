########################################################################################################################
#!!
#!   (c) Copyright 2022 Micro Focus, L.P.
#!   All rights reserved. This program and the accompanying materials
#!   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#!
#!   The Apache License is available at
#!   http://www.apache.org/licenses/LICENSE-2.0
#!
#!   Unless required by applicable law or agreed to in writing, software
#!   distributed under the License is distributed on an "AS IS" BASIS,
#!   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#!   See the License for the specific language governing permissions and
#!   limitations under the License.
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_ids_from_json_array
  inputs:
    - data_json:
        required: true
    - array_name:
        required: true
  python_action:
    use_jython: false
    script: "import json\n\ndef execute(data_json, array_name):\n    \n    if data_json == \"\":\n        return {\"return_result\": \"\", \"return_code\": -1}\n        \n    ids = \"\"\n    \n    for element in json.loads(data_json)[array_name]:\n        ids += element[\"id\"] + \",\"\n        \n    ids = ids[:-1]\n    \n    return {\"return_result\": ids, \"return_code\": 0}"
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
  results:
    - SUCCESS
