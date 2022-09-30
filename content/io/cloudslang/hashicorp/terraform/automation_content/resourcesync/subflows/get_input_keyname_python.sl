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
#
########################################################################################################################
#!!
#! @description: This operation is used to get the input key name and key value lists.
#!
#! @input input_results: Json result of inputs.
#!
#! @output input_results_keyname_list: List of input key names.
#! @output input_results_keyvalue_list: List of input key values.
#! @output result: The return result of the operation.
#!
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
operation:
  name: get_input_keyname_python
  inputs:
    - input_results
  python_action:
    use_jython: false
    script: "import json\n\n\ndef execute(input_results):\n\n    key = ' '\n    input_results_keyname_list = []\n    input_results_keyvalue_list = []\n    y = json.loads(input_results)\n    result = {}\n\n    for key in y.keys():\n        input_results_keyname_list.append(key)\n        x = list(y[key])\n        input_results_keyvalue_list.append(y[key]['value'])\n        result[key] = y[key]['value']\n    \n    input_results_keyname_list = str(input_results_keyname_list)\n    #input_results_keyname_list = input_results_keyname_list.replace(\"'\", \"\").replace(\"[\", \"\").replace(\"]\", \"\")\n    input_results_keyvalue_list = str(input_results_keyvalue_list)\n    #input_results_keyvalue_list = input_results_keyvalue_list.replace(\"'\", \"\").replace(\"[\", \"\").replace(\"]\", \"\")\n    return {'result': result, 'input_results_keyname_list': input_results_keyname_list, 'input_results_keyvalue_list': input_results_keyvalue_list}"
  outputs:
    - input_results_keyname_list
    - input_results_keyvalue_list
    - result
  results:
    - SUCCESS
