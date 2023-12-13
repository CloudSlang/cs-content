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
#! @description: This python operation can be used to retrieve the information of instance from JSON.
#!
#! @input instance_json: Instance details in JSON.
#!
#! @output metadata: The metadata of the instance.
#! @output instance_id: The id of the instance.
#! @output internal_ips: The internal IPs of the instance.
#! @output external_ips: The external IPs of the instance.
#! @output status: The status of the instance.
#! @output self_link: The server-defined URL for this resource.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2.instances.subflows
operation:
  name: get_instance_details_python
  inputs:
    - instance_json
  python_action:
    use_jython: false
    script: "import json\ndef execute(instance_json):\n    json_load = (json.loads(instance_json))\n    instance_id = json_load['id']\n    self_link = json_load['selfLink']\n    internal_ips = ''\n    external_ips = ''\n    status = json_load['status']\n    metadata = ''\n    if 'metadata' in json_load:\n        metadata = json_load['metadata']\n    for i in json_load['networkInterfaces'] :\n        if 'networkIP' in i:\n            if internal_ips == '':\n                internal_ips = i['networkIP']\n            else:\n                internal_ips = \",\" + internal_ips + i['networkIP']\n        if 'accessConfigs' in i :\n            for j in i['accessConfigs'] :\n                if 'natIP' in j:\n                    if external_ips == '':\n                        external_ips = j['natIP']\n                    else:\n                        external_ips = \",\" + external_ips + j['natIP']\n        \n    return{\"instance_id\":instance_id, \"internal_ips\": internal_ips, \"external_ips\": external_ips , \"status\": status , \"metadata\": metadata,\"self_link\":self_link}"
  outputs:
    - metadata
    - instance_id
    - internal_ips
    - external_ips
    - status
    - self_link
  results:
    - SUCCESS
