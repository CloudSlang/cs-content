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
#! @description: This operation gets the id of the terraform resource offering.
#!
#! @input ro_list: The list of resource offering.
#!
#! @output ro_id: The ID of the terraform resource offering.
#!
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
operation:
  name: get_ro_id_python
  inputs:
    - ro_list
  python_action:
    use_jython: false
    script: "import json\ndef execute(ro_list):\n    ro_id = ' '\n    y = json.loads(ro_list)\n    \n    for i in y[\"members\"]:\n        if i[\"displayName\"] == \"Terraform Automation Content 1.0.0 (CloudSlang)\":\n             ro_id = i[\"@self\"]\n             \n    \n    return {\"ro_id\":ro_id}"
  outputs:
    - ro_id
  results:
    - SUCCESS
