namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: get_created_user_id
  inputs:
    - json_obj
  python_action:
    use_jython: false
    script: "import json\r\nimport re\r\n\r\ndef execute(json_obj):\r\n    error_message = ''\r\n    return_code = 0\r\n    account_id = ''\r\n    try:\r\n       data = json.loads(json_obj)\r\n       account_id = data['accountId']\r\n    except Exception as e:\r\n        return_code = -1\r\n        error_message = str(e)\r\n    return{\"account_id\":str(account_id), \"error_message\":error_message, \"return_code\":return_code}"
  outputs:
    - account_id
    - error_message
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
