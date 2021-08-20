namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: create_body_add_user_workspace
  inputs:
    - email
    - first_name
    - last_name
    - password:
        sensitive: true
    - phone:
        required: false
    - user_role
    - name:
        required: false
    - id
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(email, first_name, last_name, phone, name, user_role, password, id):\n    body='{\"data\": [{\"email\": \"'+email +'\",\"first_name\": \"'+first_name+'\",\"last_name\": \"'+last_name+'\",\"name\": \"'+first_name+last_name+'\",\"password\": \"'+password+'\",\"phone1\": \"'+phone+'\", \"roles\": {\"data\": [{\"type\": \"'+user_role+'\",\"id\": \"1003\"}]}}]}'\n    return_code=0\n    error_message=\"\"\n    \n    try:\n        body='{\"data\": [{\"email\": \"' +email +'\",\"first_name\": \"' +first_name +'\",\"last_name\": \"' +last_name+'\",\"password\": \"'+password\n        if name:\n            body=body+'\",\"name\": \"'+name\n        if phone:\n            body=body+'\",\"phone1\": \"'+ phone\n        body=body+'\", \"roles\": {\"data\": [{\"type\": \"'+user_role+'\",\"id\":' +id+'}]}}]}'\n    except Exception as e:\n        return_code=1\n        error_message=str(e)\n    return locals()\n# you can add additional helper methods below."
  outputs:
    - body
    - error_message
    - return_code
  results:
    - SUCCESS
