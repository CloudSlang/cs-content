########################################################################################################################
#!!
#! @result WRONG_OPTION: This happens whenever the input entity given by the user doesn't match the list shown in the flow's input_entity's description.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: entity_body_creator
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
    script: "# do not remove the execute function\ndef execute(parent_type, parent_id, release_type, release_id, description, name, severity_type, severity_id, phase_type, phase_id, entity):\n    # code goes here\n    wrong_option = False\n    json_body = \"\"\n    if entity == \"defects\":\n        json_body = createDefectBody(parent_type, parent_id, release_type, release_id, description, name, severity_type, severity_id, phase_type, phase_id, entity)\n    elif entity == \"features\":\n        json_body = createFeatureBody(parent_type, parent_id, release_type, release_id, description, name, entity)\n    elif entity == \"stories\":\n        json_body = createFeatureBody(parent_type, parent_id, release_type, release_id, description, name, entity)\n    elif entity == \"epics\":\n        json_body = createEpicBody(parent_type, parent_id, description, name, entity)\n    else:\n        wrong_option = True\n    my_entity = entity\n    return locals()\n    \n# you can add additional helper methods below.\n    \n    \n    \n    \n\ndef createDefectBody(parent_type, parent_id, release_type, release_id, description, name, severity_type, severity_id, phase_type, phase_id, entity):\n    json_body = '''\n    {\n        \"data\":[{'''\n    if parent_type!= \"\" and parent_id != \"\":\n        json_body = json_body + '''\n             \"parent\":{\n                \"type\":\"''' + parent_type + '''\\\",\n                \"id\":\"''' + parent_id + '''\\\"\n            },'''\n    if release_type!= \"\" and release_id != \"\":\n        json_body = json_body +  '''\"release\":{\n                \"type\":\"''' + release_type + '''\\\",\n                \"id\":\"''' + release_id + '''\\\"\n            },'''\n    if description!= \"\":\n        json_body = json_body + '''\"description\":\"''' + description + '''\\\",'''\n    if severity_type!= \"\" and severity_id != \"\":\n         json_body = json_body + '''\"severity\":{\n                \"type\":\"''' + severity_type + '''\\\",\n                \"id\":\"''' + severity_id + '''\\\"\n            },'''\n    if phase_type!= \"\" and phase_id != \"\":\n         json_body = json_body + '''\"phase\":{\n                \"type\":\"''' + phase_type + '''\\\",\n                \"id\":\"''' + phase_id + '''\\\"\n            },'''\n\n    json_body = json_body + '''\"name\":\"''' + name + '''\\\"\n        }]\n    }\n    '''\n    return json_body\n\n\n\n\n\ndef createFeatureBody(parent_type, parent_id, release_type, release_id, description, name, entity):\n    json_body = '''\n    {\n        \"data\":[{'''\n    if parent_type!= \"\" and parent_id != \"\":\n        json_body = json_body + '''\n             \"parent\":{\n                \"type\":\"''' + parent_type + '''\\\",\n                \"id\":\"''' + parent_id + '''\\\"\n            },'''\n    if release_type!= \"\" and release_id != \"\":\n        json_body = json_body +  '''\"release\":{\n                \"type\":\"''' + release_type + '''\\\",\n                \"id\":\"''' + release_id + '''\\\"\n            },'''\n    if description!= \"\":\n        json_body = json_body + '''\"description\":\"''' + description + '''\\\",'''\n\n    json_body = json_body + '''\"name\":\"''' + name + '''\\\"\n        }]\n    }\n    '''\n    return json_body\n    \n    \ndef createEpicBody(parent_type, parent_id, description, name, entity):\n    json_body = '''\n    {\n        \"data\":[{'''\n    if parent_type!= \"\" and parent_id != \"\":\n        json_body = json_body + '''\n             \"parent\":{\n                \"type\":\"''' + parent_type + '''\\\",\n                \"id\":\"''' + parent_id + '''\\\"\n            },'''\n    if description!= \"\":\n        json_body = json_body + '''\"description\":\"''' + description + '''\\\",'''\n\n    json_body = json_body + '''\"name\":\"''' + name + '''\\\"\n        }]\n    }\n    '''\n    return json_body"
  outputs:
    - json_body
    - my_entity
  results:
    - WRONG_OPTION: '${wrong_option == "True"}'
      CUSTOM_0: '${wrong_option == "True"}'
    - SUCCESS
