namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: request_body_creator
  inputs:
    - username
    - password
  python_action:
    use_jython: false
    script: "import json\n\ndef execute(username, password): \n    return_code = 0\n    error_message = \"\"\n    json_string = '{}'\n    json_object = json.loads(json_string)\n    \n    try:\n        json_string = '{}'\n        json_object = json.loads(json_string)\n        json_object[\"user\"] = username\n        json_object[\"password\"] = password\n    except Exception as e:\n        return_code = 1\n        error_message = str(e)\n        \n    return{\"body\":str(json_object).replace(\"\\'\", \"\\\"\"), \"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - body
    - return_code
    - error_message
  results:
    - SUCCESS: "${return_code=='0'}"
    - FAILURE
