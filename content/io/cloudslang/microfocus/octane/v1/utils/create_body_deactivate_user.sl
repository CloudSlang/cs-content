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
namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: create_body_deactivate_user
  inputs:
    - id
  python_action:
    use_jython: false
    script: "def execute(id):\n    return_code=0\n    error_message=\"\"\n    \n    try:\n        body='{\"data\": [{\"ssp_user_activation_status\": ' +'1' +',\"id\": \"' +id \n        body=body+'\"}]}'\n    except Exception as e:\n        return_code=1\n        error_message=str(e)\n    return locals()"
  outputs:
    - body
    - error_message
    - return_code
  results:
    - SUCCESS
