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
  name: create_body_add_user_workspace
  inputs:
    - email
    - first_name
    - last_name
    - password:
        sensitive: true
    - phone:
        required: false
    - user_role
    - name:
        required: false
    - id
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(email, first_name, last_name, phone, name, user_role, password, id):\n    body='{\"data\": [{\"email\": \"'+email +'\",\"first_name\": \"'+first_name+'\",\"last_name\": \"'+last_name+'\",\"name\": \"'+first_name+last_name+'\",\"password\": \"'+password+'\",\"phone1\": \"'+phone+'\", \"roles\": {\"data\": [{\"type\": \"'+user_role+'\",\"id\": \"1003\"}]}}]}'\n    return_code=0\n    error_message=\"\"\n    \n    try:\n        body='{\"data\": [{\"email\": \"' +email +'\",\"first_name\": \"' +first_name +'\",\"last_name\": \"' +last_name+'\",\"password\": \"'+password\n        if name:\n            body=body+'\",\"name\": \"'+name\n        if phone:\n            body=body+'\",\"phone1\": \"'+ phone\n        body=body+'\", \"roles\": {\"data\": [{\"type\": \"'+user_role+'\",\"id\":' +id+'}]}}]}'\n    except Exception as e:\n        return_code=1\n        error_message=str(e)\n    return locals()\n# you can add additional helper methods below."
  outputs:
    - body
    - error_message
    - return_code
  results:
    - SUCCESS
