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
#! @description: Creates a JSON object with the given inputs.
#!
#! @input workspace_variables_json: Workspace variables json
#!                           Default: '1.2.0'
#! @input sensitive_workspace_variables_json: Sensitive workspace variables json.
#!                               Optional
#!
#! @output return_result: Optional property JSON.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.utils
operation:
  name: create_workspace_variables_request_body
  inputs:
    - workspace_variables_json:
        required: false
    - sensitive_workspace_variables_json:
        required: false
  python_action:
    use_jython: false
    script: "import json\ndef execute(workspace_variables_json,sensitive_workspace_variables_json):\n    \n    return_result = ''\n    \n    if workspace_variables_json != None and workspace_variables_json != '':\n        workspace_variables_json = json.loads(workspace_variables_json)\n        \n\n        for i in workspace_variables_json:\n            if return_result == '':\n                return_result = i['propertyName']+':::'+i['propertyValue']+':::'+str(i['HCL'])+':::'+i['Category']+':::false'\n            else:\n                return_result = return_result + ','+i['propertyName']+':::'+i['propertyValue']+':::'+str(i['HCL'])+':::'+i['Category']+':::false'\n    if sensitive_workspace_variables_json != None and sensitive_workspace_variables_json != '':\n        sensitive_workspace_variables_json = json.loads(sensitive_workspace_variables_json)\n        for j in sensitive_workspace_variables_json:\n            if return_result == '':\n                return_result = j['propertyName']+':::'+j['propertyValue']+':::'+str(j['HCL'])+':::'+j['Category']+':::true'\n            else:\n                return_result = return_result + ','+j['propertyName']+':::'+j['propertyValue']+':::'+str(j['HCL'])+':::'+j['Category']+':::true'\n    \n    return {'return_result': return_result}"
  outputs:
    - return_result
  results:
    - SUCCESS
