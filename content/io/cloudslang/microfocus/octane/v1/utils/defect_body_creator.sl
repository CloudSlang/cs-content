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
  name: defect_body_creator
  inputs:
    - name:
        required: false
    - parent_type:
        required: false
    - parent_id:
        required: false
    - release_type:
        required: false
    - release_id:
        required: false
    - description:
        required: false
    - severity_type:
        required: false
    - severity_id:
        required: false
    - phase_type:
        required: false
    - phase_id:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(parent_type, parent_id, release_type, release_id, description, name, severity_type, severity_id, phase_type, phase_id):\n    # code goes here\n    json_body = '''\n    { \n        \"data\":[{\n             \"parent\":{\n                \"type\":\"''' + parent_type + '''\\\",\n                \"id\":\"''' + parent_id + '''\\\"\n            },\n            \"release\":{\n                \"type\":\"''' + release_type + '''\\\",\n                \"id\":\"''' + release_id + '''\\\"\n            },\n            \"description\":\"''' + description + '''\\\",\n            \"severity\":{\n                \"type\":\"''' + severity_type + '''\\\",\n                \"id\":\"''' + severity_id + '''\\\"\n            },\n            \"phase\":{\n                \"type\":\"''' + phase_type + '''\\\",\n                \"id\":\"''' + phase_id + '''\\\"\n            },\n            \"name\":\"''' + name + '''\\\"\n        }]\n    }\n    '''\n    return locals()\n# you can add additional helper methods below."
  outputs:
    - json_body
  results:
    - SUCCESS
