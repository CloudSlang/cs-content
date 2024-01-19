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
#! @description: This operation is used to form the sensitive and non-sensitive variable JSON.
#!
#! @input property_value_list: The list of property values.
#!
#! @output sensitive_json: The sensitive variables JSON.
#! @output non_sensitive_json: The non sensitive variables JSON.
#!
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.utils
operation:
  name: create_variables_json_python
  inputs:
    - property_value_list
  python_action:
    use_jython: false
    script: "import json\ndef execute(property_value_list):\n    piplined_separated_list = property_value_list.split(\"|\")\n    value_separated_list = []\n    sensitive_json = []\n    non_sensitive_json = []\n    \n    for value in piplined_separated_list:\n        if value[:8] == \"tf_input\":\n            value_separated_list.append(value)\n            if value.split(\";\")[2] == \"false\":\n                non_sensitive_json.append({\n                    \"propertyName\": str(value.split(\";\")[0]).replace(\"tf_input_\", \"\"),\n                    \"propertyValue\": value.split(\";\")[1],\n                    \"HCL\": False,\n                    \"Category\":\"terraform\"})\n            else:\n                sensitive_json.append({\n                    \"propertyName\": str(value.split(\";\")[0]).replace(\"tf_input_\", \"\"),\n                    \"propertyValue\": value.split(\";\")[1],\n                    \"HCL\": False,\n                    \"Category\":\"terraform\"})\n                \n    return {\"sensitive_json\": json.dumps(sensitive_json), \"non_sensitive_json\": json.dumps(non_sensitive_json)}"
  outputs:
    - sensitive_json
    - non_sensitive_json
  results:
    - SUCCESS
