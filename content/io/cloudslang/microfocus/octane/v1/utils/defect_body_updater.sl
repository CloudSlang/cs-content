namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: defect_body_updater
  inputs:
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
    - name:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(parent_type, parent_id, release_type, release_id, description, name, severity_type, severity_id, phase_type, phase_id):\n    # code goes here\n    \n    valid_json = True\n    \n    json_body = '''{'''\n    if parent_type!= \"\" and parent_id != \"\":\n        json_body = json_body + '''\n             \"parent\":{\n                \"type\":\"''' + parent_type + '''\\\",\n                \"id\":\"''' + parent_id + '''\\\"\n            },'''\n    if release_type!= \"\" and release_id != \"\":\n        json_body = json_body +  '''\"release\":{\n                \"type\":\"''' + release_type + '''\\\",\n                \"id\":\"''' + release_id + '''\\\"\n            },'''\n    if description!= \"\":\n        json_body = json_body + '''\"description\":\"''' + description + '''\\\",'''\n    if severity_type!= \"\" and severity_id != \"\":\n         json_body = json_body + '''\"severity\":{\n                \"type\":\"''' + severity_type + '''\\\",\n                \"id\":\"''' + severity_id + '''\\\"\n            },'''\n    if phase_type!= \"\" and phase_id != \"\":\n         json_body = json_body + '''\"phase\":{\n                \"type\":\"''' + phase_type + '''\\\",\n                \"id\":\"''' + phase_id + '''\\\"\n            },'''\n    if name != \"\":\n        json_body = json_body + '''\"name\":\"''' + name + '''\\\"'''\n    json_body = json_body + '''}'''\n    if json_body == '''{}''':\n    \n        valid_json = False\n    \n    \n    return locals()\n# you can add additional helper methods below."
  outputs:
    - json_body
  results:
    - INVALID_BODY: '${valid_json =="False"}'
      CUSTOM_0: '${valid_json == False}'
    - SUCCESS
