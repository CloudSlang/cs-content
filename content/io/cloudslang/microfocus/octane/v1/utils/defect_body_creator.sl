namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: defect_body_creator
  inputs:
    - parent_type
    - parent_id
    - release_type
    - release_id
    - description
    - severity_type
    - severity_id
    - phase_type
    - phase_id
    - name
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(parent_type, parent_id, release_type, release_id, description, name, severity_type, severity_id, phase_type, phase_id):\n    # code goes here\n    json_body = '''\n    { \n        \"data\":[{\n             \"parent\":{\n                \"type\":\"''' + parent_type + '''\\\",\n                \"id\":\"''' + parent_id + '''\\\"\n            },\n            \"release\":{\n                \"type\":\"''' + release_type + '''\\\",\n                \"id\":\"''' + release_id + '''\\\"\n            },\n            \"description\":\"''' + description + '''\\\",\n            \"severity\":{\n                \"type\":\"''' + severity_type + '''\\\",\n                \"id\":\"''' + severity_id + '''\\\"\n            },\n            \"phase\":{\n                \"type\":\"''' + phase_type + '''\\\",\n                \"id\":\"''' + phase_id + '''\\\"\n            },\n            \"name\":\"''' + name + '''\\\"\n        }]\n    }\n    '''\n    return locals()\n# you can add additional helper methods below."
  outputs:
    - json_body
  results:
    - SUCCESS
