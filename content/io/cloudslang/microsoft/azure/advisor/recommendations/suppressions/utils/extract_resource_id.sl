#   (c) Copyright 2024 Micro Focus, L.P.
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
#########################################################################################################################
#!!
#! @description: This operation is used to extract postponed and dismissed  resource id for the list of suppressions.
#!
#! @input json_response: json response with list of suppressions
#!
#! @output dismissed_resource_id: The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
#! @output postponed_resource_id: The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
#!
#! @result SUCCESS: Successfully extracted resource id for the list of suppression
#!!#
########################################################################################################################
namespace: io.cloudslang.microsoft.azure.advisor.recommendations.suppressions.utils
operation:
  name: extract_resource_id
  inputs:
    - json_response
  python_action:
    use_jython: false
    script: "import json\r\n\r\ndef execute(json_response):\r\n    data = json.loads(json_response)\r\n\r\n    dismissed_resource_id = []\r\n    postponed_resource_id = []\r\n\r\n    for item in data['value']:\r\n        ttl = item['properties']['ttl']\r\n        if ttl == \"-1\":\r\n            dismissed_resource_id.append(item['id'])\r\n        else:\r\n            postponed_resource_id.append(item['id'])\r\n\r\n        print(\"Dismissed resource IDs:\", dismissed_resource_id)\r\n        print(\"Postponed resource IDs:\", postponed_resource_id)\r\n\r\n    return {\"dismissed_resource_id\": dismissed_resource_id, \"postponed_resource_id\": postponed_resource_id}"
  outputs:
    - dismissed_resource_id
    - postponed_resource_id
  results:
    - SUCCESS

