namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: create_body_deactivate_user
  inputs:
    - id
  python_action:
    use_jython: false
    script: "def execute(id):\n    return_code=0\n    error_message=\"\"\n    \n    try:\n        body='{\"data\": [{\"ssp_user_activation_status\": ' +'1' +',\"id\": \"' +id \n        body=body+'\"}]}'\n    except Exception as e:\n        return_code=1\n        error_message=str(e)\n    return locals()"
  outputs:
    - body
    - error_message
    - return_code
  results:
    - SUCCESS
