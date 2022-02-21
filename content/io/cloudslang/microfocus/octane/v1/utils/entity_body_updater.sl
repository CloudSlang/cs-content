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
#! @result WRONG_OPTION: This happens whenever the input entity given by the user doesn't match the list shown in the flow's input_entity's description.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: entity_body_updater
  inputs:
    - entity:
        required: false
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
    script: "# do not remove the execute function\ndef execute(parent_type, parent_id, release_type, release_id, description, name, severity_type, severity_id, phase_type, phase_id, entity):\n    # code goes here\n    wrong_option = False\n    json_body = \"\"\n    if entity == \"defects\":\n        json_body = createDefectBody(parent_type, parent_id, release_type, release_id, description, name, severity_type, severity_id, phase_type, phase_id, entity)\n    elif entity == \"features\":\n        json_body = createFeatureBody(parent_type, parent_id, release_type, release_id, description, name, entity)\n    elif entity == \"stories\":\n        json_body = createFeatureBody(parent_type, parent_id, release_type, release_id, description, name, entity)\n    elif entity == \"epics\":\n        json_body = createEpicBody(parent_type, parent_id, description, name, entity)\n    else:\n        wrong_option = True\n    my_entity = entity\n    return locals()\n    \n# you can add additional helper methods below.\n    \n    \n    \n    \n\ndef createDefectBody(parent_type, parent_id, release_type, release_id, description, name, severity_type, severity_id, phase_type, phase_id, entity):\n    json_body = '''{'''\n    if parent_type!= \"\" and parent_id != \"\":\n        json_body = json_body + '''\n             \"parent\":{\n                \"type\":\"''' + parent_type + '''\\\",\n                \"id\":\"''' + parent_id + '''\\\"\n            },'''\n    if release_type!= \"\" and release_id != \"\":\n        json_body = json_body +  '''\"release\":{\n                \"type\":\"''' + release_type + '''\\\",\n                \"id\":\"''' + release_id + '''\\\"\n            },'''\n    if description!= \"\":\n        json_body = json_body + '''\"description\":\"''' + description + '''\\\",'''\n    if severity_type!= \"\" and severity_id != \"\":\n         json_body = json_body + '''\"severity\":{\n                \"type\":\"''' + severity_type + '''\\\",\n                \"id\":\"''' + severity_id + '''\\\"\n            },'''\n    if phase_type!= \"\" and phase_id != \"\":\n         json_body = json_body + '''\"phase\":{\n                \"type\":\"''' + phase_type + '''\\\",\n                \"id\":\"''' + phase_id + '''\\\"\n            },'''\n    if name!=\"\":\n        json_body = json_body + '''\"name\":\"''' + name + '''\\\"'''\n    json_body = json_body.rstrip(\",\")\n    json_body = json_body +  '''}'''\n    \n    return json_body\n\n\n\n\n\ndef createFeatureBody(parent_type, parent_id, release_type, release_id, description, name, entity):\n    json_body = '''\n    {\n    '''\n    if parent_type!= \"\" and parent_id != \"\":\n        json_body = json_body + '''\n             \"parent\":{\n                \"type\":\"''' + parent_type + '''\\\",\n                \"id\":\"''' + parent_id + '''\\\"\n            },'''\n    if release_type!= \"\" and release_id != \"\":\n        json_body = json_body +  '''\"release\":{\n                \"type\":\"''' + release_type + '''\\\",\n                \"id\":\"''' + release_id + '''\\\"\n            },'''\n    if description!= \"\":\n        json_body = json_body + '''\"description\":\"''' + description + '''\\\",'''\n\n    if name!=\"\":\n        json_body = json_body + '''\"name\":\"''' + name + '''\\\"'''\n    json_body = json_body.rstrip(\",\")\n    json_body = json_body +  '''}'''\n    return json_body\n    \n    \ndef createEpicBody(parent_type, parent_id, description, name, entity):\n    json_body = '''\n    {\n    {'''\n    if parent_type!= \"\" and parent_id != \"\":\n        json_body = json_body + '''\n             \"parent\":{\n                \"type\":\"''' + parent_type + '''\\\",\n                \"id\":\"''' + parent_id + '''\\\"\n            },'''\n    if description!= \"\":\n        json_body = json_body + '''\"description\":\"''' + description + '''\\\",'''\n\n    if name!=\"\":\n        json_body = json_body + '''\"name\":\"''' + name + '''\\\"'''\n    json_body = json_body.rstrip(\",\")\n    json_body = json_body +  '''}'''\n    return json_body"
  outputs:
    - json_body
    - my_entity
  results:
    - WRONG_OPTION: '${wrong_option == "True"}'
      CUSTOM_0: '${wrong_option == "True"}'
    - SUCCESS
