namespace: io.cloudslang.hashicorp.terraform.resourcesync.subflows
flow:
  name: get_tf_variables
  inputs:
    - tf_user_auth_token:
        sensitive: true
    - tf_template_organization_name
    - tf_template_workspace_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
  workflow:
    - get_workspace_details:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.get_workspace_details:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - organization_name: '${tf_template_organization_name}'
            - workspace_name: '${tf_template_workspace_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - tf_template_workspace_id: '${workspace_id}'
          - workspace_info: '${return_result}'
        navigate:
          - SUCCESS: get_template_vcs_repo_identifier
          - FAILURE: on_failure
    - get_template_vcs_repo_identifier:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${workspace_info}'
            - json_path: 'data,attributes,vcs-repo-identifier'
        publish:
          - tf_template_vcs_repo_identifier: '${return_result}'
        navigate:
          - SUCCESS: list_template_workspace_variables
          - FAILURE: on_failure
    - list_template_workspace_variables:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.variables.list_workspace_variable:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - workspace_id: '${tf_template_workspace_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - tf_template_workspace_variables: '${return_result}'
        navigate:
          - SUCCESS: get_template_variables_list
          - FAILURE: on_failure
    - get_template_variables_list:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${tf_template_workspace_variables}'
            - json_path: data
        publish:
          - variables_list: '${return_result}'
        navigate:
          - SUCCESS: list_runs_in_template_workspace
          - FAILURE: on_failure
    - list_runs_in_template_workspace:
        do:
          io.cloudslang.hashicorp.terraform.resourcesync.subflows.list_runs_in_template_workspace:
            - tf_template_workspace_id: '${tf_template_workspace_id}'
            - tf_user_auth_token: '${tf_user_auth_token}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
        publish:
          - output_variable_key_list: '${output_variable_key_list}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - tf_variables_list: '${variables_list}'
    - tf_template_workspace_id: '${tf_template_workspace_id}'
    - tf_template_vcs_repo_identifier: '${tf_template_vcs_repo_identifier}'
    - output_variable_key_list: '${output_variable_key_list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_workspace_details:
        x: 40
        'y': 160
      list_runs_in_template_workspace:
        x: 680
        'y': 160
        navigate:
          c1717730-22d4-a484-d82b-3837c77191bb:
            targetId: 8a94a410-8ddd-3c39-6651-daa852ea17f7
            port: SUCCESS
      get_template_vcs_repo_identifier:
        x: 200
        'y': 160
      list_template_workspace_variables:
        x: 360
        'y': 160
      get_template_variables_list:
        x: 520
        'y': 160
    results:
      SUCCESS:
        8a94a410-8ddd-3c39-6651-daa852ea17f7:
          x: 840
          'y': 160
