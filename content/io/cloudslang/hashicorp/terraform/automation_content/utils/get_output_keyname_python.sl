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
#! @description: This operation is used to get the list of the terraform output variable key names and values.
#!
#! @input output_results: The terraform output variables JSON output.
#!
#! @output output_results_keyname_list: The list of terraform output variables key name.
#! @output output_results_keyvalue_list: The list of terraform output variables key value.
#! @output result: The return result.
#!
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.utils
operation:
  name: get_output_keyname_python
  inputs:
    - output_results
  python_action:
    use_jython: false
    script: "import json\n\n\ndef execute(output_results):\n\n    key = ' '\n    output_results_keyname_list = []\n    output_results_keyvalue_list = []\n    y = json.loads(output_results)\n    result = {}\n\n    for key in y.keys():\n        output_results_keyname_list.append(key)\n        x = list(y[key])\n        output_results_keyvalue_list.append(y[key]['value'])\n        result[key] = y[key]['value']\n    \n    output_results_keyname_list = str(output_results_keyname_list)\n    output_results_keyname_list = output_results_keyname_list.replace(\"'\", \"\").replace(\"[\", \"\").replace(\"]\", \"\")\n    output_results_keyvalue_list = str(output_results_keyvalue_list)\n    output_results_keyvalue_list = output_results_keyvalue_list.replace(\"'\", \"\").replace(\"[\", \"\").replace(\"]\", \"\")\n    return {'result': result, 'output_results_keyname_list': output_results_keyname_list, 'output_results_keyvalue_list': output_results_keyvalue_list}"
  outputs:
    - output_results_keyname_list
    - output_results_keyvalue_list
    - result
  results:
    - SUCCESS
