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
  name: get_id
  inputs:
    - json_obj
  python_action:
    use_jython: false
    script: "import json\r\nimport re\r\n\r\ndef execute(json_obj):\r\n    error_message = ''\r\n    return_code = 0\r\n    account_id = ''\r\n    try:\r\n       data = json.loads(json_obj)\r\n       account_id = data['accountId']\r\n    except Exception as e:\r\n        return_code = -1\r\n        error_message = str(e)\r\n    return{\"account_id\":str(account_id), \"error_message\":error_message, \"return_code\":return_code}"
  outputs:
    - account_id
    - error_message
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
