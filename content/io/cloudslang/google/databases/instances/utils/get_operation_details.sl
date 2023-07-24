#   (c) Copyright 2023 Open Text
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
########################################################################################################################
#!!
#! @description: This python operation can be used to retrieve the information of instance from JSON.
#!
#! @input instance_json: Instance details in JSON.
#!
#! @output self_link: The URI of this resource.
#! @output status: The status of the operation
#! @output name: The name of the operation
#!
#! @result SUCCESS: This python scccessfully retrieved the information of instance from JSON.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases.instances.utils
operation:
  name: get_operation_details
  inputs:
    - instance_json
  python_action:
    use_jython: false
    script: "import json\r\n\r\ndef execute(instance_json):\r\n    json_load = json.loads(instance_json)\r\n    self_link = json_load['selfLink']\r\n    status = json_load['status']\r\n    name = json_load['name']\r\n    \r\n    \r\n    return {\r\n        \"self_link\": self_link,\r\n        \"status\": status,\r\n         \"name\": name,\r\n        \r\n    }"
  outputs:
    - self_link
    - status
    - name
  results:
    - SUCCESS

