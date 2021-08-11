namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: create_body_activate_user
  inputs:
    - id
  python_action:
    use_jython: false
    script: "# do not remove the execute function\nimport json\ndef execute(id):\n    # code goes here\n    return_code = 0\n    error_message = \"\"\n    json_string = '{}'\n    json_object = json.loads(json_string)\n    \n    try:\n        json_string = '{}'\n        json_object = json.loads(json_string)\n        json_object[\"id\"] = id\n        json_object[\"ws_user_activation_status\"] = 0\n    except Exception as e:\n        return_code = 1\n        error_message = str(e)\n        \n    return{\"body\":str(json_object).replace(\"\\'\", \"\\\"\"), \"return_code\":return_code, \"error_message\":error_message}\n# you can add additional helper methods below."
  outputs:
    - body
    - return_code
    - error_message
  results:
    - SUCCESS
