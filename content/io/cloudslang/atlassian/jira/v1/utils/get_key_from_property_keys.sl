########################################################################################################################
#!!
#!   (c) Copyright 2022 Micro Focus, L.P.
#!   All rights reserved. This program and the accompanying materials
#!   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#!
#!   The Apache License is available at
#!   http://www.apache.org/licenses/LICENSE-2.0
#!
#!   Unless required by applicable law or agreed to in writing, software
#!   distributed under the License is distributed on an "AS IS" BASIS,
#!   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#!   See the License for the specific language governing permissions and
#!   limitations under the License.
#!!#
########################################################################################################################
########################################################################################################################
#!!
#! @description: Gets a comma separated list of isse ids
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_key_from_property_keys
  inputs:
    - return_result:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\nimport json\ndef execute(return_result):\n    return_code = 0\n    keys_list = \"\"\n    try:\n        response = json.loads(return_result)\n        total_keys = response[\"keys\"]\n        for key in total_keys:\n            keys_list = keys_list + key[\"key\"] + ','\n        keys_list = keys_list[:-1]\n    except:   \n        return_code = -1\n    \n    return {\"keys_list\" : keys_list, \"return_code\" : return_code}"
  outputs:
    - keys_list
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
