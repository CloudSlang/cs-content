namespace: io.cloudslang.hashicorp.terraform.automation_content.utils
flow:
  name: get_component_template_details_and_create_workspace_variables
  inputs:
    - component_template_id
    - tf_user_auth_token:
        required: true
        sensitive: true
    - tf_instance_workspace_id
    - dnd_username
    - user_identifier
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
  workflow:
    - get_artifact_properties:
        do:
          final.terra.rajesh.utils.get_artifact_properties:
            - user_identifier: '${user_identifier}'
            - artifact_id: '${component_template_id}'
        publish:
          - property_value_list
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_variables_json_python
    - create_variables_json_python:
        do:
          io.cloudslang.hashicorp.terraform.automation_content.utils.python_operations.create_variables_json_python:
            - property_value_list: '${property_value_list}'
        publish:
          - sensitive_json
          - non_sensitive_json
        navigate:
          - SUCCESS: create_workspace_variables
    - create_workspace_variables:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.variables.create_workspace_variables:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - workspace_id: '${tf_instance_workspace_id}'
            - workspace_variables_json: '${non_sensitive_json}'
            - sensitive_workspace_variables_json:
                value: '${sensitive_json}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - var_list: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - property_value_list: '${property_value_list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_artifact_properties:
        x: 80
        'y': 160
      create_variables_json_python:
        x: 200
        'y': 160
      create_workspace_variables:
        x: 320
        'y': 160
        navigate:
          87f991d0-0a92-3b1e-dc75-0a9957da7cb1:
            targetId: 8a42da71-eff6-fb01-3900-cb40d2bc4e36
            port: SUCCESS
    results:
      SUCCESS:
        8a42da71-eff6-fb01-3900-cb40d2bc4e36:
          x: 480
          'y': 160
