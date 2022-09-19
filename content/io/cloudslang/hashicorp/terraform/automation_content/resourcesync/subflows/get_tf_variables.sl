namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
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
        sensitive: true
    - worker_group:
        default: RAS_Operator_Path
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
    - get_workspace_details:
        worker_group: '${worker_group}'
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
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - tf_template_workspace_id: '${workspace_id}'
          - workspace_info: '${return_result}'
        navigate:
          - SUCCESS: get_template_vcs_repo_identifier
          - FAILURE: on_failure
    - get_template_vcs_repo_identifier:
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
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
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - variables_list: '${return_result}'
        navigate:
          - SUCCESS: list_runs_in_template_workspace
          - FAILURE: on_failure
    - list_runs_in_template_workspace:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.list_runs_in_template_workspace:
            - tf_template_workspace_id: '${tf_template_workspace_id}'
            - tf_user_auth_token: '${tf_user_auth_token}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - worker_group: '${worker_group}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
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
      get_template_vcs_repo_identifier:
        x: 200
        'y': 160
      list_template_workspace_variables:
        x: 360
        'y': 160
      list_runs_in_template_workspace:
        x: 520
        'y': 160
        navigate:
          c1717730-22d4-a484-d82b-3837c77191bb:
            targetId: 8a94a410-8ddd-3c39-6651-daa852ea17f7
            port: SUCCESS
    results:
      SUCCESS:
        8a94a410-8ddd-3c39-6651-daa852ea17f7:
          x: 680
          'y': 160
