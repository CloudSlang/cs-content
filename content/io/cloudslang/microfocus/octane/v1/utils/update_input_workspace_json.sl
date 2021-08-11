namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: update_input_workspace_json
  inputs:
    - name
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(name):\n    json = '''\n        {\n              \"name\":\"''' + name + '''\"\n        }'''\n \n    return locals()\n    # code goes here\n# you can add additional helper methods below."
  outputs:
    - json
  results:
    - SUCCESS
