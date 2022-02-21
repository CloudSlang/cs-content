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
namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_bulk_permissions_body
  inputs:
    - project_permissions:
        required: false
    - global_permissions:
        required: false
    - account_id:
        required: false
  python_action:
    use_jython: false
    script: "def execute(project_permissions, global_permissions, account_id):\n    \n    return_code = 0;\n    body = \"{\"\n    \n    if global_permissions != \"\":\n        body += '\"globalPermissions\": [' + \"\".join(map(lambda permission: '\"' + permission + '\",', global_permissions.split(\",\")))[:-1] + ']'\n        \n    if account_id != \"\":\n        \n        if body != \"{\": \n            body += \",\"\n            \n        body += '\"accountId\": \"' + account_id + '\"'\n        \n    if project_permissions != \"\":\n        \n        if body != \"{\": \n            body += \",\"\n            \n        body += '\"projectPermissions\": [' + project_permissions + ']'\n        \n    body += \"}\"\n    \n    return {\"return_result\": body, \"return_code\": return_code}"
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
  results:
    - SUCCESS
