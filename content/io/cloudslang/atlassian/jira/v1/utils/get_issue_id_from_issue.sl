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
#! @description: Gets the issue id
#!
#! @result FAILURE: Operation failed
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_issue_id_from_issue
  inputs:
    - return_result:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\nimport json\ndef execute(return_result):\n    return_code = 0\n    issue_id = \"\"\n    try:\n        response = json.loads(return_result)\n        issue_id = response[\"id\"]\n    except:   \n        return_code = -1\n    \n    return {\"issue_id\" : issue_id, \"return_code\" : return_code}"
  outputs:
    - issue_id
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE

