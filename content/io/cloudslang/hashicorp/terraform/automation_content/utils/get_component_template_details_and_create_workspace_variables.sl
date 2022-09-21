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
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
  workflow:
    - get_artifact_properties:
        do:
          io.cloudslang.hashicorp.terraform.automation_content.utils.get_template_properties:
            - user_identifier: '${user_identifier}'
            - artifact_id: '${component_template_id}'
        publish:
          - property_value_list
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_variables_json_python
    - create_variables_json_python:
        do:
          io.cloudslang.hashicorp.terraform.automation_content.utils.create_variables_json_python:
            - property_value_list: '${property_value_list}'
        publish:
          - sensitive_json
          - non_sensitive_json
        navigate:
          - SUCCESS: create_workspace_variables_v2
    - create_workspace_variables_v2:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.variables.create_workspace_variables_v2:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - workspace_id:
                value: '${tf_instance_workspace_id}'
                sensitive: true
            - sensitive_workspace_variables_json: '${sensitive_json}'
            - workspace_variables_json: '${non_sensitive_json}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - create_workspace_variables_output
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - property_value_list
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
      create_workspace_variables_v2:
        x: 320
        'y': 160
        navigate:
          f5ffce52-1899-2975-52db-d10900ad6a81:
            targetId: 8a42da71-eff6-fb01-3900-cb40d2bc4e36
            port: SUCCESS
    results:
      SUCCESS:
        8a42da71-eff6-fb01-3900-cb40d2bc4e36:
          x: 480
          'y': 160
