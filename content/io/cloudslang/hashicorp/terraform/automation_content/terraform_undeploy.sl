namespace: io.cloudslang.hashicorp.terraform.automation_content
flow:
  name: terraform_undeploy
  inputs:
    - tf_user_auth_token:
        sensitive: true
    - tf_instance_organization_name
    - tf_instance_workspace_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
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
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false
    - keep_alive:
        required: false
    - connections_max_per_route:
        required: false
    - connections_max_total:
        required: false
    - response_character_set:
        required: false
  workflow:
    - get_workspace_details:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.get_workspace_details:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - organization_name: '${tf_instance_organization_name}'
            - workspace_name: '${tf_instance_workspace_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - workspace_id
          - return_result
        navigate:
          - SUCCESS: get_auto_apply_value
          - FAILURE: on_failure
    - is_auto_apply_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${auto_apply}'
        navigate:
          - 'TRUE': get_run_details_for_get_state_version_details
          - 'FALSE': get_run_details_v2
    - wait_for_apply_status:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_run_details_v2
          - FAILURE: on_failure
    - get_run_details_v2:
        do:
          io.cloudslang.hashicorp.terraform.runs.get_run_details_v2:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - tf_run_id: '${tf_run_id}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - return_result
        navigate:
          - SUCCESS: get_run_status_value
          - FAILURE: on_failure
    - get_run_status_value:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'data,attributes,status'
        publish:
          - plan_status: '${return_result}'
        navigate:
          - SUCCESS: run_status
          - FAILURE: on_failure
    - run_status:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${plan_status}'
            - second_string: planned
        navigate:
          - SUCCESS: apply_run_v3
          - FAILURE: counter
    - delete_workspace:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.delete_workspace:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - organization_name: '${tf_instance_organization_name}'
            - workspace_name: '${tf_instance_workspace_name}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish: []
        navigate:
          - SUCCESS: check_workspace_is_present
          - FAILURE: on_failure
    - check_workspace_is_present:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.get_workspace_details:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - organization_name: '${tf_instance_organization_name}'
            - workspace_name: '${tf_instance_workspace_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - workspace_id
          - return_result
        navigate:
          - SUCCESS: on_failure
          - FAILURE: SUCCESS
    - get_auto_apply_value:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'data,attributes,auto-apply'
        publish:
          - auto_apply: '${return_result}'
        navigate:
          - SUCCESS: create_workspace_variables_v2
          - FAILURE: on_failure
    - counter:
        do:
          io.cloudslang.hashicorp.terraform.utils.counter:
            - from: '1'
            - to: '100'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_for_apply_status
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - get_run_details_for_get_state_version_details:
        do:
          io.cloudslang.hashicorp.terraform.runs.get_run_details_v2:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - tf_run_id: '${tf_run_id}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - return_result
        navigate:
          - SUCCESS: get_run_status_value_state_version
          - FAILURE: on_failure
    - get_run_status_value_state_version:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'data,attributes,status'
        publish:
          - plan_status: '${return_result}'
        navigate:
          - SUCCESS: run_status_for_get_state_version_details
          - FAILURE: on_failure
    - run_status_for_get_state_version_details:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${plan_status}'
            - second_string: applied
        navigate:
          - SUCCESS: delete_workspace
          - FAILURE: counter_for_get_state_version_details
    - counter_for_get_state_version_details:
        do:
          io.cloudslang.hashicorp.terraform.utils.counter:
            - from: '1'
            - to: '100'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_for_get_state_version_details
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_get_state_version_details:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_run_details_for_get_state_version_details
          - FAILURE: on_failure
    - create_workspace_variables_v2:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.variables.create_workspace_variables_v2:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - workspace_id:
                value: '${workspace_id}'
                sensitive: true
            - workspace_variables_json: '[{"propertyName":"CONFIRM_DESTROY","propertyValue":"1","HCL":false,"Category":"env"}]'
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
        navigate:
          - SUCCESS: create_run_v3
          - FAILURE: on_failure
    - create_run_v3:
        do:
          io.cloudslang.hashicorp.terraform.runs.create_run_v3:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - workspace_id:
                value: '${workspace_id}'
                sensitive: true
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
          - tf_run_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_auto_apply_true
    - apply_run_v3:
        do:
          io.cloudslang.hashicorp.terraform.runs.apply_run_v3:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - tf_run_id:
                value: '${tf_run_id}'
                sensitive: true
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
        navigate:
          - SUCCESS: get_run_details_for_get_state_version_details
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_run_status_value:
        x: 680
        'y': 280
      delete_workspace:
        x: 1286
        'y': 293
      apply_run_v3:
        x: 840
        'y': 320
      wait_for_apply_status:
        x: 493
        'y': 451
      wait_for_get_state_version_details:
        x: 974
        'y': 279
      run_status:
        x: 847
        'y': 433
      check_workspace_is_present:
        x: 1431
        'y': 295
        navigate:
          37245234-d896-8513-2a44-c4ae6a309c0d:
            targetId: 8fdcd666-d9ef-4f4f-6ed2-36400100824c
            port: FAILURE
      counter_for_get_state_version_details:
        x: 975
        'y': 450
        navigate:
          090c0377-8eaa-436b-ab07-e6c19834ad4b:
            targetId: cb4ded66-a2a7-9760-786d-84926d356dd9
            port: NO_MORE
      get_run_status_value_state_version:
        x: 975
        'y': 105
      get_workspace_details:
        x: 40
        'y': 120
      create_workspace_variables_v2:
        x: 320
        'y': 320
      get_run_details_for_get_state_version_details:
        x: 808
        'y': 108
      create_run_v3:
        x: 360
        'y': 120
      run_status_for_get_state_version_details:
        x: 1165
        'y': 267
      get_run_details_v2:
        x: 493
        'y': 279
      get_auto_apply_value:
        x: 195
        'y': 107
      is_auto_apply_true:
        x: 707
        'y': 95
      counter:
        x: 670
        'y': 455
        navigate:
          b5902390-2619-3b22-c280-1d6c7ec9bdd4:
            targetId: cb4ded66-a2a7-9760-786d-84926d356dd9
            port: NO_MORE
    results:
      FAILURE:
        cb4ded66-a2a7-9760-786d-84926d356dd9:
          x: 815
          'y': 606
      SUCCESS:
        8fdcd666-d9ef-4f4f-6ed2-36400100824c:
          x: 1588
          'y': 301
