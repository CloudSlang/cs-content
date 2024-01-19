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
#! @description: This operation is used to get the list of the terraform output variables from the given variable list.
#!
#! @input property_value_list: The list of property values.
#!
#! @output tf_output_list: The list of terraform output variables.
#!
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.utils
operation:
  name: get_tf_output_list_python
  inputs:
    - property_value_list
  python_action:
    use_jython: false
    script: "import json\ndef execute(property_value_list):\n    piplined_list = property_value_list.split(\"|\")\n    tf_output_list = []\n    for value in piplined_list:\n        if value[:9] == \"tf_output\":\n            tf_output_list.append(value)\n    \n    tf_output_list = str(tf_output_list).replace(\"[\", \"\").replace(\"]\", \"\").replace(\"'\", \"\")              \n    return {\"tf_output_list\": tf_output_list}"
  outputs:
    - tf_output_list
  results:
    - SUCCESS
