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
#! @description: Retrieves the error message from the return result.
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: test_for_http_error
  inputs:
    - return_result
  python_action:
    use_jython: false
    script: "import json\n\ndef execute(return_result):\n    \n    error_message = \"\"\n    \n    try:\n        error_message = json.loads(return_result)[\"errorMessages\"][0]\n    except:\n        error_message = return_result\n        \n    return {\"error_message\": error_message}"
  outputs:
    - error_message: '${error_message}'
  results:
    - FAILURE
