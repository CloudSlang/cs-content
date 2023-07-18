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
#! @description: This operation is used to get the output input variable list from json.
#!
#! @input data: Json data.
#!
#! @output return_result: The list of the input variables.
#!
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
operation:
  name: input_variable_list
  inputs:
    - data
  python_action:
    use_jython: false
    script: "# do not remove the execute function\r\nimport json\r\ndef execute(data):\r\n    json_load = (json.loads(data))\r\n    myval = ''\r\n   \r\n    for i in json_load['data']:\r\n        val='empty'\r\n        if i['attributes']['value'] != None:\r\n            val = i['attributes']['value']\r\n        if myval == '':\r\n            myval = i['attributes']['key']+':::'+val+':::'+str(i['attributes']['sensitive'])\r\n        else:\r\n             myval = myval + ','+i['attributes']['key']+':::'+val+':::'+str(i['attributes']['sensitive'])\r\n    return{\"return_result\":myval}\r\n        \r\n    # code goes here\r\n# you can add additional helper methods below."
  outputs:
    - return_result
  results:
    - SUCCESS
